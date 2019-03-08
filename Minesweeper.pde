ArrayList<ArrayList<Tile>> tiles;
public int rowCount;
public int columnCount;
public boolean isDed = false;
public int startTime = -1;
public int finalTime = -1;
public boolean hasGeneratedMines = false;
public int startedPressingMouseTime = -1;
public boolean hasJustPlacedFlag = false;
public long currentSeed = -1;
public boolean isEnteringSeed = false;
public int flagsLeft = GameConstants.mineCount;

public void setup()
{
  size(525, 545);

  final float kWidth = width;
  final float kHeight = height-GameConstants.scoreboardShift;
  rowCount = (int)(kWidth/(GameConstants.tileSize+GameConstants.spacing));
  columnCount = (int)(kHeight/(GameConstants.tileSize+GameConstants.spacing));

  resetGame((long)(Math.random()*Math.pow(10, GameConstants.seedLength)));

  textFont(createFont("Arial Bold", 13));

  //println("MAX MINES -- ", (rowCount*columnCount-Math.pow(GameConstants.safeArea*2+1, 2)));
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
  int minesLeft = GameConstants.mineCount;

  generateMinesLoop:
  while (minesLeft > 0)
  {
    for (int i=0; i < rowCount; i++)
    {
      for (int j=0; j < columnCount; j++)
      {
        if (!tiles.get(i).get(j).getIsMine() && random(1.0) <= 1.0*GameConstants.mineCount/(rowCount*columnCount-Math.pow(GameConstants.safeArea*2+1, 2)) && !(startRow-GameConstants.safeArea <= i && startRow+GameConstants.safeArea >= i && startColumn-GameConstants.safeArea <= j && startColumn+GameConstants.safeArea >= j))// (startRow-GameConstants.safeArea >= i || startRow+GameConstants.safeArea <= i) && (startColumn-GameConstants.safeArea >= j || startColumn+GameConstants.safeArea <= j))
        {
          tiles.get(i).get(j).setIsMine(true);
          minesLeft--;
        }

        if (minesLeft <= 0)
        {
          break generateMinesLoop;
        }
      }
    }
  }

  for (int i=0; i < rowCount; i++)
  {
    for (int j=0; j < columnCount; j++)
    {
      ArrayList<Integer> neighborCoords = getNeighborCoordinates(i, j);
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

public ArrayList<Integer> getNeighborCoordinates(int row, int column)
{
  ArrayList<Integer> neighborCoords = new ArrayList<Integer>();
  if (row+1 < rowCount) { neighborCoords.add(row+1); neighborCoords.add(column); }
  if (row-1 >= 0) { neighborCoords.add(row-1); neighborCoords.add(column); }
  if (column+1 < columnCount) { neighborCoords.add(row); neighborCoords.add(column+1); }
  if (column-1 >= 0) { neighborCoords.add(row); neighborCoords.add(column-1); }
  if (row+1 < rowCount && column+1 < columnCount) { neighborCoords.add(row+1); neighborCoords.add(column+1); }
  if (row-1 >= 0 && column-1 >= 0) { neighborCoords.add(row-1); neighborCoords.add(column-1); }
  if (row-1 >= 0 && column+1 < columnCount) { neighborCoords.add(row-1); neighborCoords.add(column+1); }
  if (row+1 < rowCount && column-1 >= 0) { neighborCoords.add(row+1); neighborCoords.add(column-1); }
  return neighborCoords;
}

public void draw()
{
  background(204);
  fill(0);
  textAlign(CENTER);
  text((finalTime == -1) ? ((startTime == -1) ? 0 : (millis()-startTime)/1000) : (finalTime), width/2, 20);
  text(nf((int)currentSeed, GameConstants.seedLength), width/4, 20);
  text(flagsLeft, width*3/4, 20);

  int showingTiles = 0;
  for (int i=0; i < tiles.size(); i++)
    for (int j=0; j < tiles.get(i).size(); j++)
      if (tiles.get(i).get(j).getIsShowing() || (tiles.get(i).get(j).getIsFlagged() && tiles.get(i).get(j).getIsMine()))
        showingTiles++;

  if (showingTiles == rowCount*columnCount && finalTime == -1)
  {
    finalTime = (millis()-startTime)/1000;
  }

  if (startedPressingMouseTime > 0 && millis()-startedPressingMouseTime >= GameConstants.timeToPlaceFlag)
  {
    checkForTileClicked(RIGHT);
    startedPressingMouseTime = -1;
    hasJustPlacedFlag = true;
  }

  translate(0, GameConstants.scoreboardShift);
  for (int i=0; i < tiles.size(); i++)
    for (int j=0; j < tiles.get(i).size(); j++)
      tiles.get(i).get(j).show(i*GameConstants.tileSize + ((i+1)*GameConstants.spacing), j*GameConstants.tileSize + ((j+1)*GameConstants.spacing));
}

public void mousePressed()
{
  startedPressingMouseTime = millis();
}

public void mouseReleased()
{
  //println(countMinesLeft());
  if (!hasJustPlacedFlag)
  {
    checkForTileClicked(mouseButton);
  }
  hasJustPlacedFlag = false;
  startedPressingMouseTime = -1;
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
      }
    }
  }
}

public void keyPressed()
{
  if (!isEnteringSeed)
  {
    switch (keyCode)
    {
    case 67:
      showTiles();
      break;
    case 82:
      resetGame((long)(Math.random()*Math.pow(10, GameConstants.seedLength)));
      break;
    case 84:
      resetGame(currentSeed);
      break;
    case 32:
      handleClick(rowCount/2, columnCount/2, LEFT, tiles.get(rowCount/2).get(columnCount/2));
      break;
    case 13:
    case 10:
      isEnteringSeed = true;
      currentSeed = 0;
      break;
    case 69:
      if (GameConstants.devEnabled) println(countMines());
      break;
    default:
      //println(keyCode);
      break;
    }
  }
  else
  {
    switch (keyCode)
    {
    case 10:
    case 13:
      isEnteringSeed = false;
      break;
    default:
      if (keyCode-48 < 10)
      {
        currentSeed = currentSeed*10 + keyCode-48;
        resetGame(currentSeed);
      }
      break;
    }
  }
}

public void handleClick(int row, int column, int button, Tile originalTile)
{
  startTime = (startTime == -1) ? millis() : startTime;
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
        for (int i=0; i < tiles.size(); i++)
          for (int j=0; j < tiles.get(i).size(); j++)
            if ((!tiles.get(i).get(j).getIsMine() && tiles.get(i).get(j).getIsFlagged()) || (tiles.get(i).get(j).getIsMine() && !tiles.get(i).get(j).getIsFlagged())) tiles.get(i).get(j).setIsShowing(true);
      }
      else
      {
        tile.setIsShowing(true);

        ArrayList<Integer> neighborCoords = getNeighborCoordinates(row, column);
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
      flagsLeft += 1*(tile.getIsFlagged() ? -1 : 1);
    }
    else if (button == LEFT && originalTile.getIsShowing() && originalTile.getNeighborCount() > 0)
    {
      ArrayList<Integer> neighborCoords = getNeighborCoordinates(row, column);
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

public void resetGame(long seed)
{
  tiles = new ArrayList<ArrayList<Tile>>();
  createTiles();
  startTime = -1;
  finalTime = -1;
  isDed = false;
  flagsLeft = GameConstants.mineCount;
  hasGeneratedMines = false;
  currentSeed = seed;
  randomSeed(currentSeed);
}

public void showTiles()
{
  if (GameConstants.devEnabled)
  {
    for (int i=0; i < tiles.size(); i++)
    {
      for (int j=0; j < tiles.get(i).size(); j++)
      {
        tiles.get(i).get(j).setIsShowing(!tiles.get(i).get(j).getIsShowing());
      }
    }
  }
}

public int countMines()
{
  int mines = 0;
  for (int i=0; i < tiles.size(); i++)
  {
    for (int j=0; j < tiles.get(i).size(); j++)
    {
      mines += tiles.get(i).get(j).getIsMine() ? 1 : 0;
    }
  }

  return mines;
}

public int countMinesLeft()
{
  int mines = 0;
  for (int i=0; i < tiles.size(); i++)
  {
    for (int j=0; j < tiles.get(i).size(); j++)
    {
      mines += (tiles.get(i).get(j).getIsMine() && !tiles.get(i).get(j).getIsFlagged()) ? 1 : 0;
    }
  }

  return mines;
}
