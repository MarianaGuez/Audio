 /**
 * A simple example of how to do FFT with FFTW3 and JACK.
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <jack/jack.h>

// Include FFTW header
#include <complex.h> //needs to be included before fftw3.h for compatibility
#include <fftw3.h>

// filtro
double complex *i_fft, *i_time, *i_fft2, *i_time2, *i_fft_he, *i_time_he, *o_fft, *o_time, *o_fft2, *o_time2;
int *filter;
fftw_plan i_forward, o_inverse, i_forward_he, o_inverse_he, i_forward2, o_inverse2;
jack_port_t *input_port_1;
//jack_port_t *input_port_2;
jack_port_t *output_port_1;
//jack_port_t *output_port_2;
jack_client_t *client;
double *freqs;
double sample_rate;

//buffers
int buffer_size = 2048;
int nframes = 1024;
jack_default_audio_sample_t *b1, *b2, *b3, *b4, hann[2048], *temp;
void Filtro(jack_default_audio_sample_t *apBuffer);

// desfase
double PI = acos(-1);
/*
freqs[nframes/2] = sample_rate/2;
filter[0] = 0.0;
*
 * The process callback for this JACK application is called in a
 * special realtime thread once for each audio cycle.
 *
 * This client does nothing more than copy data from its input
 * port to its output port. It will exit when stopped by
 * the user (e.g. using Ctrl-C on a unix-ish operating system)
 */

int jack_callback (jack_nframes_t nframes, void *arg){
  jack_default_audio_sample_t *in_1, *in_2, *out_1, *out_2;
  int i;
  in_1 = jack_port_get_buffer (input_port_1, nframes);
 // in_2 = jack_port_get_buffer (input_port_2, nframes);
  out_1 = jack_port_get_buffer (output_port_1, nframes);
 //out_2 = jack_port_get_buffer (output_port_2, nframes);

  /*for( i = 0; i < nframes; ++i){
    out1[i] = b3[i];
    b3[i] = in1[i];
  }*/

  for(i = 0; i < nframes; ++i){
    b2[i+nframes] = in_1[i];
  }

  Filtro(b2);

  for(i = 0; i < nframes; ++i){
    out_1[i] = b1[i+nframes] + b2[i];
  }

  temp = b1;
  b1 = b2;
  b2 = temp;
  for(i = 0; i < nframes; ++i){
    b2[i] = in_1[i];
  }

 for(i = 0; i < nframes; ++i){
    i_time[i] =  in_1[i];
 }
  return 0;
}


/**
 * JACK calls this shutdown_callback if the server ever shuts down or
 * decides to disconnect the client.
 */
void jack_shutdown (void *arg){
  exit (1);
}

void Filtro(jack_default_audio_sample_t *apBuffer){
  int i;
  for( i = 0; i < buffer_size; ++i){
    apBuffer[i] *= hann[i];
    i_time[i] = apBuffer[i];
  }

  fftw_execute(i_forward);

  for(i = 0; i < buffer_size; ++i){
    o_fft[i] = i_fft[i]*i_fft_he[i];
  }
  // Regresando al dominio del tiempo
  fftw_execute(o_inverse);

  for( i = 0; i < buffer_size; ++i){
    o_time[i] = creal(o_time[i])/buffer_size;
    o_time[i] *= hann[i];
    apBuffer[i] = o_time[i];
  }
}



int main (int argc, char *argv[]) {

   b1 = malloc(sizeof(jack_default_audio_sample_t)*2048);
   b2 = malloc(sizeof(jack_default_audio_sample_t)*2048);
 // b3 = malloc(sizeof(jack_default_audio_sample_t)*2048);
 // b4 = malloc(sizeof(jack_default_audio_sample_t)*2048);
   int i;

   for( i = 0; i < buffer_size; ++i){
     hann[i] = sqrt(0.5*(1-cos((2*3.1416*(i))/buffer_size)));
   }


  const char *client_name = "jack_fft";
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
  printf ("Sample rate: %d\n", jack_get_sample_rate (client));
  printf ("Window size: %d\n", jack_get_buffer_size (client));
  sample_rate = (double)jack_get_sample_rate(client);
  int nframes = jack_get_buffer_size (client);

  /*prepare frequency array*/
  freqs = (double *) malloc(sizeof(double) * nframes);
  filter = (double *) malloc(sizeof(double) * nframes);



  i_fft_he = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);
  i_time_he = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);
  i_forward_he = fftw_plan_dft_1d(buffer_size, i_time_he, i_fft_he , FFTW_FORWARD, FFTW_MEASURE);

  double fc1 = 2*PI*(12000/sample_rate);
  double fc2 = 2*PI*(1500/sample_rate);
  for(int i = -nframes; i < nframes; ++i){
    //filtro pasa bajas
    i_time_he[i+1025] = (sin(i*fc2)/(PI*i));
  }

  i_time_he[1205] = (fc2/PI);
  fftw_execute(i_forward_he);

  //preparing FFTW3 buffers
  i_fft = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);
  i_time = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);
  o_fft = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);
  o_time = (double complex *) fftw_malloc(sizeof(double complex) * buffer_size);

  i_forward = fftw_plan_dft_1d(buffer_size, i_time, i_fft , FFTW_FORWARD, FFTW_MEASURE);
  o_inverse = fftw_plan_dft_1d(buffer_size, o_fft , o_time, FFTW_BACKWARD, FFTW_MEASURE);

  //Channel 2
  /*i_fft2 = (double complex *) fftw_malloc(sizeof(double complex) * (nframes*2));
  i_time2 = (double complex *) fftw_malloc(sizeof(double complex) * (nframes*2));
  o_fft2 = (double complex *) fftw_malloc(sizeof(double complex) * (nframes*2));
  o_time2 = (double complex *) fftw_malloc(sizeof(double complex) * (nframes*2));

  i_forward2 = fftw_plan_dft_1d(nframes, i_time2, i_fft2 , FFTW_FORWARD, FFTW_MEASURE);
  o_inverse2 = fftw_plan_dft_1d(nframes, o_fft2, o_time2, FFTW_BACKWARD, FFTW_MEASURE);

  /* create the agent input port */
  input_port_1 = jack_port_register (client, "input", JACK_DEFAULT_AUDIO_TYPE,JackPortIsInput, 0);
  //input_port_2 = jack_port_register (client, "input2", JACK_DEFAULT_AUDIO_TYPE,JackPortIsInput, 0);

  /* create the agent output port */
  output_port_1 = jack_port_register (client, "output",JACK_DEFAULT_AUDIO_TYPE,JackPortIsOutput, 0);

  //output_port_2 = jack_port_register (client, "output2",JACK_DEFAULT_AUDIO_TYPE,JackPortIsOutput, 0);
  /* check that both ports were created succesfully */
  if ((input_port_1 == NULL) || (output_port_1 == NULL) ) {
    printf("Could not create agent ports. Have we reached the maximum amount of JACK agent ports?\n");
    exit (1);
  }

  /* Tell the JACK server that we are ready to roll.
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
  /*if (jack_connect (client, serverports_names[0], jack_port_name (input_port_1))) {
    printf("Cannot connect input port.\n");
    exit (1);
  }*/
 /* if (jack_connect (client, serverports_names[1], jack_port_name (input_port_1))) {
    printf("Cannot connect input port.\n");
    exit (1);
  }*/
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
 /* if (jack_connect (client, jack_port_name (output_port_1), serverports_names[0])) {
    printf ("Cannot connect output ports.\n");
    exit (1);
  }*/

 /* if (jack_connect (client, jack_port_name (output_port_2), serverports_names[1])) {
    printf ("Cannot connect output ports.\n");
    exit (1);
  }*/
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
