/*The Wave class provides methods to create and modify an animated wave pattern 
It is implemented as a sum of sine waves, of which the parameters are changed randomly in ranges determined by the user.
The algorithm used is adapted from this Lua example by gamedev.stackexchange.com user Anko: https://gamedev.stackexchange.com/questions/44547/how-do-i-create-2d-water-with-dynamic-waves */

class Wave implements Drawable{
  int nwaves;
  float[] offsets; //offset of the sine
  float[] amplitudes; //amplitude (vertical size factor) of the sine
  float[] sineStretches; //amount by which the sine is stretched
  float[] phaseStretches; //multiplication factor for the sine's initial phase
  float radius;
  float waveWidth;
  float xstart;
  float ystart;
  float maxHeight;
  float waveCompression;
  
  public Wave(int nwaves, float maxHeight, float waveCompression, float xstart, float ystart, float waveWidth, float radius){
    this.maxHeight = maxHeight;
    this.waveCompression = waveCompression;
    this.nwaves = nwaves;
    this.xstart = xstart;
    this.ystart = ystart;
    this.waveWidth = waveWidth;
    this.radius = radius;
    initWaveParameters(nwaves, maxHeight, waveCompression);
  }
  
  //Initialize Parameters of each component of the wave
  //the wave is composed of a sum of sine waves
  void initWaveParameters(int nwaves, float maxHeight, float waveCompression){
    offsets = new float[nwaves]; //offset of the sine
    amplitudes = new float[nwaves]; //amplitude (vertical size factor) of the sine
    sineStretches = new float[nwaves]; //amount by which the sine is stretched
    phaseStretches = new float[nwaves]; //multiplication factor for the sine's initial phase
    
    for (int i=0; i < nwaves; i++){
      offsets[i] = -1 + 2 * random(1);
      amplitudes[i] = random(0,1) * maxHeight;
      sineStretches[i] = random(0,1) * waveCompression;
      phaseStretches[i] = random(0,1) * waveCompression;
    }
  }
  
  float summedWaves(float x, float initPhase){
    return summedWaves(x, initPhase, nwaves, offsets, amplitudes, sineStretches, phaseStretches);
  }
   
  float summedWaves(float x, float base_offset, int nwaves, float[] offsets, float[] amplitudes, float[] sineStretches, float[] phaseStretches){
    float y = 0;
    for (int i=0; i < nwaves; i++){
      y += offsets[i] + amplitudes[i] * sin(x * sineStretches[i] + base_offset * phaseStretches[i]); 
    }
    return y;
  }
  
  float getSummedWaves(float x, float base_offset){
    return summedWaves(x, base_offset, nwaves, offsets, amplitudes, sineStretches, phaseStretches);
  }
  
  void display(){
    float xprev = xstart;
    float yprev = ystart + getSummedWaves(0,sin(time));
    int npoints = 10*int(waveWidth / (radius*2));
    initWaveParameters(nwaves, maxHeight, waveCompression); 
    for(int x = 1; x < npoints; x++){
      stroke(255);
      fill(255);
      float currentx = xstart+x*radius/4;
      float currenty = ystart + getSummedWaves(x,sin(time));
      //ellipse(currentx, currenty, radius, radius);
      line(xprev, yprev, currentx,currenty);
      xprev = currentx;
      yprev = currenty;
    }
  }
  
  Wave getMoved(float xmove, float ymove){
    float sign = 1;
    if(this.ystart  >= ymove) sign = -1; 
    return new Wave(this.nwaves, this.maxHeight, this.waveCompression, xmove - waveWidth/2, ymove - this.maxHeight*sign, this.waveWidth, this.radius);
  }
  
  Wave getScaled(float scaleFactor){
    return new Wave(nwaves, maxHeight + scaleFactor, waveCompression, xstart, ystart, waveWidth + scaleFactor, radius);
  }
  
   boolean isOnObject(float xtest, float ytest){
    if(xtest >= xstart && xtest <= xstart + waveWidth
       && ytest >= ystart-maxHeight && ytest <= ystart + maxHeight){
      return true;
    }
    return false;
   }
}
