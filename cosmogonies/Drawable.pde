interface Drawable{
  void display();
  Drawable getMoved(float x, float y);
  boolean isOnObject(float x, float y);
  Drawable getScaled(float scaleFactor);
}
