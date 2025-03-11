import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private boolean gameOver = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup (){
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
}

public void setMines(){
    //your code
    while (mines.size() < NUM_ROWS) {
      int r = (int)(Math.random() * NUM_ROWS);
      int c = (int)(Math.random() * NUM_COLS);
      if (!mines.contains(buttons[r][c])) {
        mines.add(buttons[r][c]);
      }
    }
}

public void draw (){
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
    else if (gameOver == true) {
        displayLosingMessage();
    }
}

public boolean isWon(){
    //your code here
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
          return false;
        }
      }
    }
    displayWinningMessage();
    return false;
}

public void displayLosingMessage(){
    //your code here
    for (MSButton mine : mines) { // using for each loop
      mine.setLabel("X");
    }
    fill(255, 0, 0); // red
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Game Over", width / 2, height / 2);
}

public void displayWinningMessage(){
    //your code here
    fill(0, 255, 0); // green 
    textSize(20);
    textAlign(CENTER, CENTER);
    text("You Win!", width / 2, height / 2);
}

public boolean isValid(int r, int c){
    //your code here
    //return false;
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}

public int countMines(int row, int col){
    int numMines = 0;
    //your code here
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;
        if (isValid(newRow, newCol) && mines.contains(buttons[newRow][newCol])) {
          numMines++;
        }
      }
    }
    return numMines;
}

public class MSButton{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col ){
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed (){
        if (flagged || clicked) return;
            clicked = true;
            //your code here

        if (mines.contains(this)) {
            gameOver = true;
        }

        else{
            int mineCount = countMines(myRow, myCol);
            if (mineCount > 0) {
                setLabel(mineCount); // display # of neighboring mines
            }  

             else {
               for (int i = -1; i <= 1; i++) {
                 for (int j = -1; j <= 1; j++) {
                   int newRow = myRow + i;
                   int newCol = myCol + j;
                   if (isValid(newRow, newCol) && !buttons[newRow][newCol].clicked) {
                     buttons[newRow][newCol].mousePressed();
                   }
                 }
               }
             }
          }
    }

    public void draw (){    
        if (flagged)
            fill(0);
        // else if( clicked && mines.contains(this) ) 
        //     fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }

    public void setLabel(String newLabel){
        myLabel = newLabel;
    }

    public void setLabel(int newLabel){
        myLabel = ""+ newLabel;
    }

    public boolean isFlagged(){
        return flagged;
    }
}
