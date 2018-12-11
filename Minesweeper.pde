ArrayList<ArrayList<Tile>> tiles;
public static final rowCount = 10;
public static final columnCount = 10;

public void setup()
{
  tiles = new ArrayList<ArrayList<Tile>>();
  createTiles();
}

public void createTiles()
{
  for (int i=0; i < rowCount; i++)
  {
    tiles.add(new ArrayList<Tile>());
  }

  for (int i=0; i < tiles.size(); i++)
  {
    ArrayList<Tile> currentRow = tiles.get(i);
  }
}

public ArrayList<Integer> getNeighborCoordinates(int row, int column)
{
  ArrayList<Integer> neighborCoords = new ArrayList<Integer>();
  if (row+1 < rowCount) { neighborCoords.add(row+1); neighborCoords.add(column); }
  if (row-1 < rowCount) { neighborCoords.add(row-1); neighborCoords.add(column); }
  if (column+1 < columnCount) { neighborCoords.add(row); neighborCoords.add(column+1); }
  if (column-1 < columnCount) { neighborCoords.add(row); neighborCoords.add(column-1); }
  if (row+1 < rowCount && column+1 < columnCount) { neighborCoords.add(row+1); neighborCoords.add(column+1); }
  if (row-1 < rowCount && column-1 < columnCount) { neighborCoords.add(row-1); neighborCoords.add(column-1); }
  if (row-1 < rowCount && column+1 < columnCount) { neighborCoords.add(row-1); neighborCoords.add(column+1); }
  if (row+1 < rowCount && column-1 < columnCount) { neighborCoords.add(row+1); neighborCoords.add(column-1); }
  return neighborCoords
}

public void draw()
{

}
