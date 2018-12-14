public class Tile
{
  private boolean isMine;
  private int neighborCount;
  private boolean isShowing;
  private float x, y;
  private boolean isFlagged;

  public Tile(double randomFactor)
  {
    isMine = ((Math.random()) < randomFactor);
    isShowing = false;
    neighborCount = 0;
  }

  public void setNeighborCount(int count) { neighborCount = count; }
  public int getNeighborCount() { return neighborCount; }
  public boolean getIsMine() { return isMine; }
  public void setIsShowing(boolean showing) { isShowing = showing; }
  public boolean getIsShowing() { return isShowing; }
  public void setIsFlagged(boolean flagged) { isFlagged = flagged; }
  public boolean getIsFlagged() { return isFlagged; }

  public void show(float x, float y)
  {
    fill(100);
    strokeWeight(1);
    stroke(150);
    if (isMine && isShowing)
    {
      fill(255, 0, 0);
    }

    if (!isMine && isShowing)
    {
      fill(240);
    }

    if (!isShowing && isFlagged)
    {
      fill(255, 255, 50);
    }

    rect(x, y, GameConstants.tileSize, GameConstants.tileSize);
    if (!isMine && isShowing && neighborCount != 0)
    {
      textAlign(CENTER);
      fill(0);
      text(neighborCount, x+(GameConstants.tileSize/2)+1, y+(GameConstants.tileSize/2)+5);
    }

    this.x = x;
    this.y = y;
  }

  public boolean isInside(int x, int y)
  {
    return ((this.x < x) && ((this.x+GameConstants.tileSize) > x) && (this.y < y) && ((this.y+GameConstants.tileSize) > y));
  }
}
