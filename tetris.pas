program Tetris;
uses Crt;

const
  BoardWidth = 10;
  BoardHeight = 22;

type
  TBoard = array [0..BoardHeight, 0..BoardWidth] of Integer;
  TTetromino = array [1..4, 1..4] of Integer;

var
  Board: TBoard;
  CurrentTetromino: TTetromino;
  TetrominoX, TetrominoY: Integer;

procedure InitializeBoard(var Board: TBoard);
begin
  // Initialize the board with zeroes and borders
end;

procedure GenerateTetromino(var Tetromino: TTetromino);
begin
  // Generate a new random tetromino
end;

procedure DrawBoard(Board: TBoard);
begin
  // Draw the current state of the board
end;

function IsValidMove(Board: TBoard; Tetromino: TTetromino; X, Y: Integer): Boolean;
begin
  // Check if the tetromino can be placed at position (X, Y)
end;

procedure RotateTetromino(var Tetromino: TTetromino);
begin
  // Rotate the tetromino 90 degrees clockwise
end;

procedure MergeTetromino(var Board: TBoard; Tetromino: TTetromino; X, Y: Integer);
begin
  // Merge the tetromino with the board at position (X, Y)
end;

function ClearLines(var Board: TBoard): Integer;
begin
  // Clear full lines and return the number of cleared lines
end;

procedure HandleInput(var Key: Char; var Board: TBoard; var Tetromino: TTetromino; var X, Y: Integer);
begin
  // Handle user input (moving and rotating the tetromino)
end;

procedure RunGame;
begin
  // Main game loop
end;

begin
  Randomize;
  RunGame;
end.

procedure InitializeBoard(var Board: TBoard);
var
  i, j: Integer;
begin
  for i := 0 to BoardHeight do
    for j := 0 to BoardWidth do
      if (i = BoardHeight) or (j = 0) or (j = BoardWidth) then
        Board[i, j] := 1
      else
        Board[i, j] := 0;
end;

procedure GenerateTetromino(var Tetromino: TTetromino);
const
  Tetrominoes: array [1..7, 1..4, 1..4] of Integer = (
    ((0, 0, 0, 0), (0, 1, 1, 0), (0, 1, 1, 0), (0, 0, 0, 0)),
    ((0, 1, 0, 0), (0, 1, 1, 0), (0, 0, 1, 0), (0, 0, 0, 0)),
    ((0, 0, 1, 0), (0, 1, 1, 0), (0, 1, 0, 0), (0, 0, 0, 0)),
    ((0, 1, 0, 0), (0, 1, 0, 0), (0, 1, 1, 0), (0, 0, 0, 0)),
    ((0, 0, 1, 0), (0, 0, 1, 0), (0, 1, 1, 0), (0, 0, 0, 0)),
    ((0, 1, 0, 0), (0, 1, 0, 0), (0, 1, 0, 0), (0, 1, 0, 0)),
    ((0, 1, 0, 0), (0, 1, 0, 0), (0, 1, 1, 0), (0, 0, 0, 0))
  );
begin
  Tetromino := Tetrominoes[Random(7) + 1];
end;

procedure DrawBoard(Board: TBoard);
var
  i, j: Integer;
begin
  for i := 0 to BoardHeight do
  begin
    for j := 0 to BoardWidth do
      if Board[i, j] <> 0 then
        Write('#')
      else
        Write(' ');
    Writeln;
  end;
end;

function IsValidMove(Board: TBoard; Tetromino: TTetromino; X, Y: Integer): Boolean;
var
  i, j: Integer;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
      if (Tetromino[i, j] <> 0) and (Board[Y + i, X + j] <> 0) then
        Exit(False);
  Result := True;
end;

procedure RotateTetromino(var Tetromino: TTetromino);
var
  i, j: Integer;
  Temp: TTetromino;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
      Temp[j, 5 - i] := Tetromino[i, j];
  Tetromino := Temp;
end;

procedure MergeTetromino(var Board: TBoard; Tetromino: TTetromino; X, Y: Integer);
var
  i, j: Integer;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
      if Tetromino[i, j] <> 0 then
        Board[Y + i, X + j] := Tetromino[i, j];
end;

function ClearLines(var Board: TBoard): Integer;
var
  i, j, k: Integer;
  LineFull: Boolean;
begin
  Result := 0;
  for i := BoardHeight - 1 downto 1 do
  begin
    LineFull := True;
    for j := 1 to BoardWidth - 1 do
      if Board[i, j] = 0 then
      begin
        LineFull := False;
        Break;
      end;

    if LineFull then
    begin
      for k := i to 2 do
        Board[k] := Board[k - 1];
      Inc(Result);
    end;
  end;
end;

procedure HandleInput(var Key: Char; var Board: TBoard; var Tetromino: TTetromino; var X, Y: Integer);
begin
  case Key of
    'a', 'A':
      if IsValidMove(Board, Tetromino, X - 1, Y) then
        Dec(X);
    'd', 'D':
      if IsValidMove(Board, Tetromino, X + 1, Y) then
        Inc(X);
    's', 'S':
      if IsValidMove(Board, Tetromino, X, Y + 1) then
        Inc(Y);
    'w', 'W':
      begin
        RotateTetromino(Tetromino);
        if not IsValidMove(Board, Tetromino, X, Y) then
          RotateTetromino(Tetromino);
      end;
  end;
end;

procedure RunGame;
var
  Key: Char;
  GameOver: Boolean;
begin
  InitializeBoard(Board);
  GameOver := False;

  while not GameOver do
  begin
    GenerateTetromino(CurrentTetromino);
    TetrominoX := (BoardWidth div 2) - 2;
    TetrominoY := 0;

    while IsValidMove(Board, CurrentTetromino, TetrominoX, TetrominoY + 1) do
    begin
      ClrScr;
      MergeTetromino(Board, CurrentTetromino, TetrominoX, TetrominoY);
      DrawBoard(Board);
      MergeTetromino(Board, CurrentTetromino, TetrominoX, TetrominoY);

      if KeyPressed then
      begin
        Key := ReadKey;
        HandleInput(Key, Board, CurrentTetromino, TetrominoX, TetrominoY);
      end;

      Delay(500);
      Inc(TetrominoY);
    end;

    MergeTetromino(Board, CurrentTetromino, TetrominoX, TetrominoY);
    ClearLines(Board);

    if not IsValidMove(Board, CurrentTetromino, TetrominoX, 0) then
      GameOver := True;
  end;
end;
