ArrayList<ArrayList<Tile>> tiles;
public int rowCount;
public int columnCount;

public void setup()
{
  tiles = new ArrayList<ArrayList<Tile>>();
  size(400, 400);

  final float kWidth = width;
  final float kHeight = height;
  rowCount = (int)(kWidth/(GameConstants.tileSize+GameConstants.spacing));
  columnCount = (int)(kHeight/(GameConstants.tileSize+GameConstants.spacing));
  createTiles();

  noLoop();
  draw();
}

public void createTiles()
{
  for (int i=0; i < rowCount; i++)
  {
    tiles.add(new ArrayList<Tile>());
  }

  for (int i=0; i < rowCount; i++)
  {
    ArrayList<Tile> currentRow = tiles.get(i);
    for (int j=0; j < columnCount; j++)
    {
      currentRow.add(new Tile(0.1));
    }
  }

  for (int i=0; i < rowCount; i++)
  {
    for (int j=0; j < columnCount; j++)
    {
      ArrayList<Integer> neighborCoords = getNeighborCoordinates(i, j, true);
      int mineCount = 0;
      for (int k=0; k < neighborCoords.size(); k+=2)
      {
        if (tiles.get(neighborCoords.get(k)).get(neighborCoords.get(k+1)).getIsMine())
        {
          mineCount++;
        }
      }
      tiles.get(i).get(j).setNeighborCount(mineCount);
    }
  }
}

public ArrayList<Integer> getNeighborCoordinates(int row, int column, boolean diagonals)
{
  ArrayList<Integer> neighborCoords = new ArrayList<Integer>();
  if (row+1 < rowCount) { neighborCoords.add(row+1); neighborCoords.add(column); }
  if (row-1 >= 0) { neighborCoords.add(row-1); neighborCoords.add(column); }
  if (column+1 < columnCount) { neighborCoords.add(row); neighborCoords.add(column+1); }
  if (column-1 >= 0) { neighborCoords.add(row); neighborCoords.add(column-1); }
  if (diagonals)
  {
    if (row+1 < rowCount && column+1 < columnCount) { neighborCoords.add(row+1); neighborCoords.add(column+1); }
    if (row-1 >= 0 && column-1 >= 0) { neighborCoords.add(row-1); neighborCoords.add(column-1); }
    if (row-1 >= 0 && column+1 < columnCount) { neighborCoords.add(row-1); neighborCoords.add(column+1); }
    if (row+1 < rowCount && column-1 >= 0) { neighborCoords.add(row+1); neighborCoords.add(column-1); }
  }
  return neighborCoords;
}

public void draw()
{
  for (int i=0; i < tiles.size(); i++)
    for (int j=0; j < tiles.get(i).size(); j++)
      tiles.get(i).get(j).show(i*GameConstants.tileSize + ((i+1)*GameConstants.spacing), j*GameConstants.tileSize + ((j+1)*GameConstants.spacing));
}

public void mousePressed()
{
  for (int i=0; i < tiles.size(); i++)
  {
    for (int j=0; j < tiles.get(i).size(); j++)
    {
      if (tiles.get(i).get(j).isInside(mouseX, mouseY))
      {
        handleClick(i, j, mouseButton, tiles.get(i).get(j));
      }
    }
  }

  redraw();
}

public void keyPressed()
{
  if (keyCode == 32)
  {
    for (int i=0; i < tiles.size(); i++)
    {
      for (int j=0; j < tiles.get(i).size(); j++)
      {
        tiles.get(i).get(j).setIsShowing(!tiles.get(i).get(j).getIsShowing());
      }
    }
  }

  redraw();
}

public void handleClick(int row, int column, int button, Tile originalTile)
{
  Tile tile = tiles.get(row).get(column);
  if (button == LEFT && !tile.getIsShowing() && !tile.getIsFlagged())
  {
    if (tile.getIsMine())
    {
      tile.setIsShowing(true);
      println("ded");
    }
    else
    {
      tile.setIsShowing(true);

      ArrayList<Integer> neighborCoords = getNeighborCoordinates(row, column, true);
      int flaggedNeighborCount = 0;
      for (int k=0; k < neighborCoords.size(); k+=2)
      {
        Tile currentTile = tiles.get(neighborCoords.get(k)).get(neighborCoords.get(k+1));
        if (!currentTile.getIsMine() && tile.getNeighborCount() == 0)
        {
          handleClick(neighborCoords.get(k), neighborCoords.get(k+1), button, originalTile);
        }
      }
    }
  }
  else if (button == RIGHT && !tile.getIsShowing())
  {
    tile.setIsFlagged(!tile.getIsFlagged());
  }
  else if (button == LEFT && originalTile.getIsShowing() && originalTile.getNeighborCount() > 0)
  {
    ArrayList<Integer> neighborCoords = getNeighborCoordinates(row, column, true);
    int flaggedNeighborCount = 0;
    for (int k=0; k < neighborCoords.size(); k+=2)
    {
      Tile currentTile = tiles.get(neighborCoords.get(k)).get(neighborCoords.get(k+1));
      if (currentTile.getIsFlagged())
      {
        flaggedNeighborCount++;
      }
    }

    if (originalTile.getNeighborCount() <= flaggedNeighborCount)
    {
      for (int k=0; k < neighborCoords.size(); k+=2)
      {
        Tile currentTile = tiles.get(neighborCoords.get(k)).get(neighborCoords.get(k+1));
        if (!currentTile.getIsFlagged())
        {
          currentTile.setIsShowing(true);
          if (currentTile.getIsMine())
          {
            println("ded");
          }
        }
      }
    }
  }
}
