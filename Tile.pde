public class Tile
{
  private boolean isMine;
  private int neighborCount;

  public Tile(double randomFactor)
  {
    isMine = Math.random()*randomFactor;
  }

  public setNeighborCount(int count) { neighborCount = count; }
  public getNeighborCount() { return neighborCount; }
  public getIsMine() { return isMine; }
}
