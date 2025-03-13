class Grid
{
   float _cellSize;
   int _nRows;
   int _nCols;
   int _numCells;

   ArrayList<ArrayList<Particle>> _cells;
   color [] _colors;

   Grid(float cellSize)
   {
      _cellSize = cellSize;
      _nRows = int(height/_cellSize);
      _nCols = int(width/_cellSize);
      _numCells = _nRows*_nCols;

      _cells  = new ArrayList<ArrayList<Particle>>();
      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
         ArrayList<Particle> cell = new ArrayList<Particle>();
         _cells.add(cell);
         _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)), 150);
      }
   }

   
int getCelda (PVector l){
    int cell = 0;
    
    int fila = int(l.y / _cellSize);
    
    cell = (fila + (int(l.x / _cellSize)*_nCols));
    
    if (cell < 0 || cell >=_cells.size()) {
      return 0;
    } else {
      return cell;
    }
  }


   void pintar(){
      strokeWeight(1);
      stroke(255,0,0);
      for(int i = 0; i <_nRows*_nCols; i++){
        line(0, i*_cellSize, width, i*_cellSize);
        line(i*_cellSize, 0, i*_cellSize, height);
      }  
    }
   
   void insertar(Particle p){
    
    int cell = getCelda(p._s);
    
    _cells.get(cell).add(p);
  }

   void restart(){
    //Resetear celdas
    for (int i = 0; i<_numCells; i++){
      _cells.get(i).clear();
    }
      

  }
 
}
