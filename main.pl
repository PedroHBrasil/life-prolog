% List Index (1D) to World Location (2D) mapping.
cell_row(Idx, NCols, Row) :-
  Row is Idx div NCols.
cell_col(Idx, NCols, Col) :-
  Col is Idx rem NCols.
cell_idx(NCols, Row, Col, Idx) :-
  Idx is Col + (Row * NCols).

% Coordinate validation
valid_coord(NRows, NCols, RowCalc, ColCalc, Row, Col) :-
  (RowCalc is -1 -> Row is NRows - 1;
   RowCalc is NRows -> Row is 0;
   Row is RowCalc),
  (ColCalc is -1 -> Col is NCols - 1;
   ColCalc is NCols -> Col is 0;
   Col is ColCalc).

% Cells' neighbors locations
neighbors_actual(_, _, [], []).
neighbors_actual(NRows, NCols, NeighborsCalc, Neighbors) :-
  NeighborsCalc = [HeadCalc|TailCalc],
  HeadCalc = [RowCalc, ColCalc],
  valid_coord(NRows, NCols, RowCalc, ColCalc, Row, Col),
  neighbors_actual(NRows, NCols, TailCalc, NeighborsTmp),
  Neighbors = [[Row, Col]|NeighborsTmp].
neighbors(NRows, NCols, CellRow, CellCol, Neighbors) :-
  CalcRow0 is CellRow - 1,
  CalcRow1 is CellRow,
  CalcRow2 is CellRow + 1,
  CalcCol0 is CellCol - 1,
  CalcCol1 is CellCol,
  CalcCol2 is CellCol + 1,
  NeighborsCalc = [
    [CalcRow0, CalcCol0],
    [CalcRow0, CalcCol1],
    [CalcRow0, CalcCol2],
    [CalcRow1, CalcCol0],
    [CalcRow1, CalcCol2],
    [CalcRow2, CalcCol0],
    [CalcRow2, CalcCol1],
    [CalcRow2, CalcCol2]
  ],
  neighbors_actual(NRows, NCols, NeighborsCalc, Neighbors).

% Alive neighbors count
alive_neighbors_count(_, _, [], 0).
alive_neighbors_count(Population, NCols, Neighbors, Count) :-
  Neighbors = [HeadNeighbor|TailNeighbors],
  HeadNeighbor = [NeighborRow, NeighborCol],
  cell_idx(NCols, NeighborRow, NeighborCol, NeighborIdx),
  alive_neighbors_count(Population, NCols, TailNeighbors, CountTmp),
  (nth0(NeighborIdx, Population, alive) -> Count is CountTmp + 1;
   Count is CountTmp).

% next_cell_state(CellState, NeighborCount, NextCellState).
next_cell_state(alive, 2, alive).
next_cell_state(_, 3, alive).
next_cell_state(_, _, dead).

% Generates a random population
random_population(0, []).
random_population(Length, Population) :-
  random_member(CellState, [alive, dead]),
  LengthTemp is Length - 1,
  random_population(LengthTemp, PopulationTemp),
  Population = [CellState|PopulationTemp], !.

update_loop(NRows, _, Row, _, _, []) :-
  NRows is Row.
update_loop(NRows, NCols, Row, Col, OldPopulation, NewPopulation) :-
  neighbors(NRows, NCols, Row, Col, Neighbors),
  alive_neighbors_count(OldPopulation, NCols, Neighbors, AliveNeighborsCount),
  cell_idx(NCols, Row, Col, CurrentCellIdx),
  nth0(CurrentCellIdx, OldPopulation, OldCellState),
  next_cell_state(OldCellState, AliveNeighborsCount, NewCellState),
  NextCellIdx is CurrentCellIdx + 1,
  cell_row(NextCellIdx, NCols, NextRow),
  cell_col(NextCellIdx, NCols, NextCol),
  update_loop(NRows, NCols, NextRow, NextCol, OldPopulation, NewPopulationTemp),
  NewPopulation = [NewCellState|NewPopulationTemp].

init_population(NRows, NCols, Population) :-
  Length is NRows * NCols,
  random_population(Length, Population).

update_population(NRows, NCols, OldPopulation, NextPopulation) :-
  update_loop(NRows, NCols, 0, 0, OldPopulation, NextPopulation).

print_cell(NRows, _, Row, _, _) :-
  NRows is Row.
print_cell(NRows, NCols, Row, Col, Population) :-
  cell_idx(NCols, Row, Col, Idx),
  nth0(Idx, Population, State),
  (State = alive -> write('\x2B1C\');
   State = dead -> write('\x2B1B\')),
  CalcCol is Col + 1,
  (CalcCol is NCols -> (
    nl,
    NextCol is 0,
    NextRow is Row + 1
  );
  NextCol is CalcCol,
  NextRow is Row),
  print_cell(NRows, NCols, NextRow, NextCol, Population).

print_population(NRows, NCols, Population) :-
  print_cell(NRows, NCols, 0, 0, Population).

run_loop(NRows, NCols, Population, "y") :-
  update_population(NRows, NCols, Population, NextPopulation),
  print_population(NRows, NCols, NextPopulation),
  write("Continue to next step (y|n)?"), nl,
  read_line_to_string(user_input, Input),
  run_loop(NRows, NCols, NextPopulation, Input).
run_loop(_, _, _, "n") :- abort().
run_loop(NRows, NCols, Population, Input) :-
  Input \= "y",
  Input \= "n",
  write("Invalid input. Please enter either 'y' to update the population or 'n' to stop execution."), nl,
  read_line_to_string(user_input, NewInput),
  run_loop(NRows, NCols, Population, NewInput).

run(NRows, NCols) :-
  init_population(NRows, NCols, Population),
  print_population(NRows, NCols, Population),
  write("Continue to next step (y|n)?"), nl,
  read_line_to_string(user_input, Input),
  run_loop(NRows, NCols, Population, Input).
