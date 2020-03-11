import de.bezier.guido.*;
private static final int NUM_ROWS = 10;
private static final int NUM_COLS = 10;
private static final int NUM_MINES = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mines

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r = r + 1) {
        for(int c = 0; c < NUM_COLS; c = c + 1) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    
    setMines();
}
public void setMines()
{
    while(mines.size() < NUM_MINES) {
        int r = (int)(Math.random() * NUM_ROWS);
        int c = (int)(Math.random() * NUM_COLS);
        if(!mines.contains(buttons[r][c])) {
            mines.add(buttons[r][c]);
            System.out.println(r + " " +  c);
        } 
    }
}

public void draw ()
{
    background(0);
    if(isWon() == true) {
        displayWinningMessage();
    }
}
public boolean isWon()
{
    int countClicked = 0;
    int countBomb = 0;
    for(int r = 0; r < NUM_ROWS; r = r + 1) {
        for(int c = 0; c < NUM_COLS; c = c + 1) {
            if(buttons[r][c].clicked) {
                countClicked = countClicked + 1;
            }
            if(mines.contains(buttons[r][c])) {
                countBomb = countBomb + 1;
            }
            if(NUM_ROWS * NUM_COLS == countClicked + countBomb) {
                return true;
            }
        }
    }
    return false;
}
public void displayLosingMessage()
{
    System.out.println("lose");
    for(int r = 1; r < NUM_ROWS; r = r + 3) {
        for(int c = 1; c < NUM_COLS; c = c + 3) {
            buttons[r][c].setLabel("lose!");
        }
    }
}
public void displayWinningMessage()
{
    noLoop();
    System.out.println("win");
    for(int r = 1; r < NUM_ROWS; r = r + 3) {
        for(int c = 1; c < NUM_COLS; c = c + 3) {
            buttons[r][c].setLabel("win!");
        }
    }
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r <= NUM_ROWS - 1 && c >= 0 && c <= NUM_COLS - 1) {
        return true;
    } else {
        return false;
    }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r < row + 2; r = r + 1) {
        for(int c = col - 1; c < col + 2; c = c + 1) {
            if(isValid(r, c)) {
                if(r == row && c == col) { //not self
                    numMines = numMines;
                } else if(mines.contains(buttons[r][c])) { //is a mine
                    numMines = numMines + 1;
                } else {

                }
            }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
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
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
            flagged = !flagged;
            if(flagged == false) {
                clicked = false;
            }
        } else if(mines.contains(this)) {
            displayLosingMessage();
        } else if(countMines(this.myRow, this.myCol) > 0) {
            this.setLabel(countMines(this.myRow, this.myCol));
        } /*else if(countMines(this.myRow, this.myCol) == 0) {
              for(int r = this.myRow-1; r <= this.myRow + 1; r = r + 1) {
                for(int c = this.myCol-1; c <= this.myCol + 1; c = c + 1) {
                    if(isValid(this.myRow + r, this.myCol + c) && !mines.contains(buttons[this.myRow + r][this.myCol + c]) && buttons[r][c].clicked == false) {
                        buttons[this.myRow + r][this.myCol + c].mousePressed();
                    }
                }
            }
        } */else {
            int num_mines = countMines(this.myRow, this.myCol);
            if(num_mines == 0) {
                for(int r = this.myRow-1; r <= this.myRow + 1; r = r + 1) {
                    for(int c = this.myCol-1; c <= this.myCol + 1; c = c + 1) {
                        if((c != 0 || r != 0) && isValid(this.myRow + r, this.myCol + c) && !mines.contains(buttons[this.myRow + r][this.myCol + c])) {
                            buttons[this.myRow + r][this.myCol + c].mousePressed();
                        }
                    }
                }
            }
            
        }
    }
    
    public void draw () 
    {    
        if (flagged) {
            fill(0);
        } else if( clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textAlign(CENTER);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}



