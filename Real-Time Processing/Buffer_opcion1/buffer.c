/**
 * A simple 1-input to 1-output JACK client.
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#include <jack/jack.h>
#include <math.h>
jack_port_t *input_port1;
jack_port_t *output_port2;
jack_port_t *output_port1;
jack_client_t *client;

//
#define PI = 3.1416
int b1_i = 0;
int b2_i = 1024;
int buffer_size = 2048;
int desfase;
int out_i;
int nframes = 1024;
double sample_rate;
void ventana(jack_default_audio_sample_t *apBuffer);
jack_default_audio_sample_t *b1, *b2, hann[2048], b3[1024], *temp;
/**
 * The process callback for this JACK application is called in a
 * special realtime thread once for each audio cycle.
 * This client does nothing more than copy data from its input
 * port to its output port. It will exit when stopped by
 * the user (e.g. using Ctrl-C on a unix-ish operating system)
 */

int jack_callback (jack_nframes_t nframes, void *arg){
  jack_default_audio_sample_t *in1, *out1, *out2;
  int i;
  in1 = jack_port_get_buffer (input_port1, nframes);
  out1 = jack_port_get_buffer (output_port1, nframes);
  out2 = jack_port_get_buffer (output_port2, nframes);

   for( i = 0; i < nframes; ++i){
    out1[i] = b3[i];
    b3[i] = in1[i];
  }

  for(i = 0; i < nframes; ++i){
    b2[i+nframes] = in1[i];
  }
  ventana(b2);

  for(i = 0; i < nframes; ++i){
    out2[i] = b1[i+nframes] + b2[i];
  }
 /* for(i = 0; i < buffer_size; ++i){
    b1[i] = b2[i];
  }*/
  temp = b1;
  b1 = b2;
  b2 = temp;
  for(i = 0; i < nframes; ++i){
    b2[i] = in1[i];
  }

  //memcpy (out, in, nframes * sizeof (jack_default_audio_sample_t));
  return 0;
}


/**
 * JACK calls this shutdown_callback if the server ever shuts down or
 * decides to disconnect the client.
 */
void jack_shutdown (void *arg){
  exit (1);
}
void ventana(jack_default_audio_sample_t *apBuffer){
  int i;
  for( i = 0; i < buffer_size; ++i){
    apBuffer[i] *= hann[i];
  }

}

int main (int argc, char *argv[]) {

  b1 = malloc(sizeof(jack_default_audio_sample_t)*2048);
  b2 = malloc(sizeof(jack_default_audio_sample_t)*2048);

  int i;
  for( i = 0; i < buffer_size; ++i){
    hann[i] = 0.5*(1-cos((2*3.1416*(i))/buffer_size));
    if(i %10 == 0 ){
      printf("%d .- %f\n", i, hann[i]);
    }
  }
 /* if (argc < 2){
   printf("Necesito los segundos a desfasar");
   exit(1);
  }
  float buffer_size_secs = atof(argv[1]);
  printf("desfasando %f",buffer_size_secs);*/

  const char *client_name = "Buffer";
  jack_options_t options = JackNoStartServer;
  jack_status_t status;

  /* open a client connection to the JACK server */
  client = jack_client_open (client_name, options, &status);


  if (client == NULL){
    /* if connection failed, say why */
    printf ("jack_client_open() failed, status = 0x%2.0x\n", status);
    if (status & JackServerFailed) {
      printf ("Unable to connect to JACK server.\n");
    }
    exit (1);
  }

  /* if connection was successful, check if the name we proposed is not in use */
  if (status & JackNameNotUnique){
    client_name = jack_get_client_name(client);
    printf ("Warning: other agent with our name is running, `%s' has been assigned to us.\n", client_name);
  }

  /* tell the JACK server to call 'jack_callback()' whenever there is work to be done. */
  jack_set_process_callback (client, jack_callback, 0);


  /* tell the JACK server to call 'jack_shutdown()' if it ever shuts down,
     either entirely, or if it just decides to stop calling us. */
  jack_on_shutdown (client, jack_shutdown, 0);


  /* display the current sample rate. */
  printf ("Engine sample rate: %d\n", jack_get_sample_rate (client));


  /* display the current window size. */
  printf ("Engine window size: %d\n", jack_get_buffer_size (client));

  /* create the agent input port */
  input_port1 = jack_port_register (client, "input", JACK_DEFAULT_AUDIO_TYPE,JackPortIsInput, 0);

  output_port1 = jack_port_register (client, "output_1", JACK_DEFAULT_AUDIO_TYPE,JackPortIsOutput, 0);
  /* create the agent output port */
  output_port2 = jack_port_register (client, "output_2",JACK_DEFAULT_AUDIO_TYPE,JackPortIsOutput, 0);

  /* check that both ports were created succesfully */
  if ((input_port1 == NULL) || (output_port2 == NULL) || (output_port1 == NULL)) {
    printf("Could not create agent ports. Have we reached the maximum amount of JACK agent ports?\n");
    exit (1);
  }
  /* desfase = buffer_size_secs*sample_rate;
  printf("Desfasando la entrada por %d muestras", desfase);
  buffer = malloc(buffer_size *sizeof(double));
  Tell the JACK server that we are ready to roll.
     Our jack_callback() callback will start running now. */
  if (jack_activate (client)) {
    printf ("Cannot activate client.");
    exit (1);
  }


  printf ("Agent activated.\n");

  /* Connect the ports.  You can't do this before the client is
   * activated, because we can't make connections to clients
   * that aren't running.  Note the confusing (but necessary)
   * orientation of the driver backend ports: playback ports are
   * "input" to the backend, and capture ports are "output" from
   * it.
   */
  printf ("Connecting ports... ");

  /* Assign our input port to a server output port*/
  // Find possible output server port names
  const char **serverports_names;
  serverports_names = jack_get_ports (client, NULL, NULL, JackPortIsPhysical|JackPortIsOutput);
  if (serverports_names == NULL) {
    printf("No available physical capture (server output) ports.\n");
    exit (1);
  }
  // Connect the first available to our input port
  if (jack_connect (client, serverports_names[0], jack_port_name (input_port1))) {
    printf("Cannot connect input port.\n");
    exit (1);
  }
  // free serverports_names variable for reuse in next part of the code
  free (serverports_names);


  /* Assign our output port to a server input port*/
  // Find possible input server port names
  serverports_names = jack_get_ports (client, NULL, NULL, JackPortIsPhysical|JackPortIsInput);
  if (serverports_names == NULL) {
    printf("No available physical playback (server input) ports.\n");
    exit (1);
  }
  // Connect the first available to our output port
  if (jack_connect (client, jack_port_name (output_port1), serverports_names[0])) {
    printf ("Cannot connect output ports.\n");
    exit (1);
  }
   if (jack_connect (client, jack_port_name (output_port2), serverports_names[1])) {
    printf ("Cannot connect output2 ports.\n");
    exit (1);
  }
  // free serverports_names variable, we're not going to use it again
  free (serverports_names);


  printf ("done.\n");
  /* keep running until stopped by the user */
  sleep (-1);


  /* this is never reached but if the program
     had some other way to exit besides being killed,
     they would be important to call.
  */
  jack_client_close (client);
  exit (0);
}

