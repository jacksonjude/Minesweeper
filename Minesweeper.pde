ArrayList<ArrayList<Tile>> tiles;
public int rowCount;
public int columnCount;
public boolean isDed;
public int startTime = -1;
public int finalTime = -1;
public boolean hasGeneratedMines = false;

public void setup()
{
  tiles = new ArrayList<ArrayList<Tile>>();
  size(700, 730);

  final float kWidth = width;
  final float kHeight = height-GameConstants.scoreboardShift;
  rowCount = (int)(kWidth/(GameConstants.tileSize+GameConstants.spacing));
  columnCount = (int)(kHeight/(GameConstants.tileSize+GameConstants.spacing));
  createTiles();

  isDed = false;

  //noLoop();
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
      currentRow.add(new Tile());
    }
  }
}

public void generateMines(int startRow, int startColumn)
{
  //tiles.get(rowCount/2).get(columnCount/2).setIsMine(false);

  int minesLeft = GameConstants.mineCount;
  while (minesLeft > 0)
  {
    for (int i=0; i < rowCount; i++)
    {
      for (int j=0; j < columnCount; j++)
      {
        //println(startRow, startColumn, (startRow-GameConstants.safeArea >= i || startRow+GameConstants.safeArea <= i), (startColumn-GameConstants.safeArea >= j || startColumn+GameConstants.safeArea <= j), i, j);
        if (!tiles.get(i).get(j).getIsMine() && Math.random() <= 1.0*GameConstants.mineCount/(rowCount*columnCount) && !(startRow-GameConstants.safeArea <= i && startRow+GameConstants.safeArea >= i && startColumn-GameConstants.safeArea <= j && startColumn+GameConstants.safeArea >= j))// (startRow-GameConstants.safeArea >= i || startRow+GameConstants.safeArea <= i) && (startColumn-GameConstants.safeArea >= j || startColumn+GameConstants.safeArea <= j))
        {
          tiles.get(i).get(j).setIsMine(true);
          minesLeft--;
        }
      }
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
  background(204);
  fill(0);
  textAlign(CENTER);
  text((finalTime == -1) ? ((startTime == -1) ? 0 : (millis()-startTime)/1000) : (finalTime), width/2, 20);

  int showingTiles = 0;
  for (int i=0; i < tiles.size(); i++)
    for (int j=0; j < tiles.get(i).size(); j++)
      if (tiles.get(i).get(j).getIsShowing() || (tiles.get(i).get(j).getIsFlagged() && tiles.get(i).get(j).getIsMine()))
        showingTiles++;

  if (showingTiles == rowCount*columnCount && finalTime == -1)
  {
    finalTime = (millis()-startTime)/1000;
  }

  translate(0, GameConstants.scoreboardShift);
  for (int i=0; i < tiles.size(); i++)
    for (int j=0; j < tiles.get(i).size(); j++)
      tiles.get(i).get(j).show(i*GameConstants.tileSize + ((i+1)*GameConstants.spacing), j*GameConstants.tileSize + ((j+1)*GameConstants.spacing));
}

public void mousePressed()
{
  checkForTileClicked(mouseButton);
}

public void checkForTileClicked(int button)
{
  for (int i=0; i < tiles.size(); i++)
  {
    for (int j=0; j < tiles.get(i).size(); j++)
    {
      if (tiles.get(i).get(j).isInside(mouseX, (int)(mouseY-GameConstants.scoreboardShift)))
      {
        handleClick(i, j, button, tiles.get(i).get(j));
        startTime = (startTime == -1) ? millis() : startTime;
      }
    }
  }
}

public void keyPressed()
{
  if (keyCode == 67)
  {
    for (int i=0; i < tiles.size(); i++)
    {
      for (int j=0; j < tiles.get(i).size(); j++)
      {
        tiles.get(i).get(j).setIsShowing(!tiles.get(i).get(j).getIsShowing());
      }
    }
  }
  else if (keyCode == 32)
  {
    tiles = new ArrayList<ArrayList<Tile>>();
    createTiles();
    startTime = -1;
    finalTime = -1;
    isDed = false;
    hasGeneratedMines = false;
  }
}

public void handleClick(int row, int column, int button, Tile originalTile)
{
  if (!hasGeneratedMines)
  {
    generateMines(row, column);
    hasGeneratedMines = true;
  }

  if (!isDed)
  {
    Tile tile = tiles.get(row).get(column);
    if (button == LEFT && !tile.getIsShowing() && !tile.getIsFlagged())
    {
      if (tile.getIsMine())
      {
        tile.setIsShowing(true);
        isDed = true;
        finalTime = (millis()-startTime)/1000;
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
            if (currentTile.getNeighborCount() == 0)
            {
              handleClick(neighborCoords.get(k), neighborCoords.get(k+1), LEFT, currentTile);
            }
            currentTile.setIsShowing(true);
            if (currentTile.getIsMine())
            {
              isDed = true;
              finalTime = (millis()-startTime)/1000;
            }
          }
        }
      }
    }
  }
}
