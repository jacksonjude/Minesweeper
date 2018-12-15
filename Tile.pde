public class Tile
{
  private boolean isMine;
  private int neighborCount;
  private boolean isShowing;
  private float x, y;
  private boolean isFlagged;

  public Tile()
  {
    isShowing = false;
  }

  public void setNeighborCount(int count) { neighborCount = count; }
  public int getNeighborCount() { return neighborCount; }
  public void setIsMine(boolean mine) { isMine = mine; }
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
      fill(220);
    }

    if (!isShowing && isFlagged)
    {
      fill(255, 255, 50);
    }

    rect(x, y, GameConstants.tileSize, GameConstants.tileSize);

    if (!isMine && isShowing && neighborCount != 0)
    {
      textAlign(CENTER);
      textFont(createFont("Arial Bold", 13));
      switch (neighborCount)
      {
      case 1:
        fill(21, 25, 249);
        break;
      case 2:
        fill(2, 125, 31);
        break;
      case 3:
        fill(253, 22, 32);
        break;
      case 4:
        fill(5, 0, 102);
        break;
      case 5:
        fill(135, 13, 18);
        break;
      case 6:
        fill(3, 127, 127);
        break;
      default:
        fill(0);
        break;
      }
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
