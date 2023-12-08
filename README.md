# Life Prolog

This is a simple implementation of the famous Conway's Game of Life in Prolog. My motivation was simply to implement something using a pure logical paradigm in order to get a better grasp of it.

## Execution

To run the program, first make sure you have Prolog [installed](https://www.swi-prolog.org/download/stable) in your system.

Then, on your terminal:
1. Navigate to the database file's ([main.pl](./main.pl)) directory.
2. Run the command `swipl` to enter Prolog's environment.
3. Run the command/consult `run({NRows}, {NCols})`, replacing `{NRows}` and `{NCols}` by the number of rows and columns that you want your simulation to have.
4. Input either `y` to update the population and display it or `n` to abort (finish) the execution.

## Contributing

Contributions are welcome! What I implemented is very basic, but if you feel inspired, you may implement some stuff yourself! Here are some ideas:

- _Automatic Population Update_: user inputs the number of next steps to execute and the program runs them without the need of input.
- _Custom Updates' Time Step_: let the user set a number of seconds or milliseconds between automatic population updates.
- _Pretty UI_: displaying the game on the terminal is quick, easy and is feasible using pure prolog. If you're interested in trainning some frontend skills, you're more than welcome to implement a UI in whichever platform you choose: web, desktop, mobile (not sure if Prolog would work here), or whatever is feasible!