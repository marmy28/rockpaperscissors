import std.algorithm.iteration : filter;
import std.algorithm.searching : all;
import std.array : array, empty, front;
import std.ascii : isLower;
import std.conv : to;
import std.getopt : getopt, defaultGetoptPrinter;
import std.string : strip, toLower;
import std.random : uniform;
import std.range : takeOne;
import std.stdio : readln, writefln, writeln;
import std.traits : EnumMembers;

// if you add to the number of choices here make sure
// to add the options into the getResult function
enum GameChoices : ubyte
{
    rock,
    paper,
    scissors
}
enum MatchOutcome : ubyte
{
    win,
    lose,
    tie
}
/**
* Looks at both the users choice and the computers choice to determine the matches outcome.
**/
MatchOutcome getResult(in GameChoices userChoice, in GameChoices computerChoice) nothrow pure @safe @nogc
{
    if (userChoice == computerChoice)
        return MatchOutcome.tie;
    else
    {
        final switch (userChoice) with (GameChoices)
        {
            case rock:
                if (computerChoice == GameChoices.scissors)
                    return MatchOutcome.win;
                break;
            case scissors:
                if (computerChoice == GameChoices.paper)
                    return MatchOutcome.win;
                break;
            case paper:
                if (computerChoice == GameChoices.rock)
                    return MatchOutcome.win;
                break;
        }
        return MatchOutcome.lose;
    }
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.rock) == MatchOutcome.tie);
    assert(getResult(GameChoices.paper, GameChoices.paper) == MatchOutcome.tie);
    assert(getResult(GameChoices.scissors, GameChoices.scissors) == MatchOutcome.tie);
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.paper) == MatchOutcome.lose);
    assert(getResult(GameChoices.paper, GameChoices.scissors) == MatchOutcome.lose);
    assert(getResult(GameChoices.scissors, GameChoices.rock) == MatchOutcome.lose);
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.scissors) == MatchOutcome.win);
    assert(getResult(GameChoices.paper, GameChoices.rock) == MatchOutcome.win);
    assert(getResult(GameChoices.scissors, GameChoices.paper) == MatchOutcome.win);
}
@safe unittest
{
    immutable firstChoice = uniform!GameChoices;
    assert(getResult(firstChoice, firstChoice) == MatchOutcome.tie);
    GameChoices secondChoice = uniform!GameChoices;
    while (firstChoice == secondChoice) { secondChoice = uniform!GameChoices; }
    // if the choices are not the same then it should never be tie
    assert(getResult(firstChoice, secondChoice) != MatchOutcome.tie);
}
/**
* Compares a game choice with a string user input. This looks at the entire string
* or just the first letter if the user input is only 1 letter
**/
bool isGameChoiceEqualToUserInput(in GameChoices gameChoice, in char[] userChoice) @safe pure
in
{
    // this make sure the input is not null
    assert(userChoice !is null);
    // this make sure that the programmer put all of the characters into their lower form
    assert(userChoice.all!(a => isLower(a)));
}
body
{
    // if the user did not enter anything then it won't match any of the options
    if (userChoice.empty) return false;
    immutable i = gameChoice.to!string.toLower;
    // this match rock to rock or r to rock but not rump to rock
    return i == userChoice || (userChoice.length == 1 && i.front == userChoice.front);
}
///
@safe unittest
{
    assert(isGameChoiceEqualToUserInput(uniform!GameChoices(), "") == false);
    assert(isGameChoiceEqualToUserInput(GameChoices.paper, "pumpkin") == false);
    assert(isGameChoiceEqualToUserInput(GameChoices.rock, "p") == false);
    assert(isGameChoiceEqualToUserInput(GameChoices.rock, "paper") == false);
    assert(isGameChoiceEqualToUserInput(GameChoices.rock, "asdf") == false);
}
///
pure @safe unittest
{
    assert(isGameChoiceEqualToUserInput(GameChoices.paper, "p") == true);
    assert(isGameChoiceEqualToUserInput(GameChoices.paper, "paper") == true);
}
/**
* Asks the user what choice they want to make, if the input matches any of the
* options then result is returned. If not then the question is asked again.
**/
GameChoices getUserChoice()
{
    immutable gameChoiceArra = [EnumMembers!GameChoices];
    writefln("Choose: %(%s, %) or quit.", gameChoiceArra);
    immutable choice = readln.strip.toLower;
    auto results = gameChoiceArra.filter!(a => isGameChoiceEqualToUserInput(a, choice))().array();
    if (results.length == 1)
        return results.front;
    else if (choice == "quit" || choice == "q")
        throw new ExitException();
    else
        return getUserChoice();
}
/**
* Gets a random option of one of the game choices.
**/
GameChoices getComputerChoice() @safe
{
    return uniform!GameChoices();
}
/**
* For each game, the user chooses and then the computer chooses.
* The choices are compared and a winner is declared.
* Once a player reaches the number of wins required this function returns if the user won or not.
**/
MatchOutcome playRockPaperScissors(in ubyte numberOfWinsRequired)
{
    ubyte userWins, computerWins = 0;
    while (userWins < numberOfWinsRequired && computerWins < numberOfWinsRequired)
    {
        immutable userChoice = getUserChoice();
        immutable computerChoice = getComputerChoice();
        writefln("The computer chose %s", computerChoice);
        immutable matchResult = getResult(userChoice, computerChoice);
        writefln("You %s", matchResult);
        final switch (matchResult) with (MatchOutcome)
        {
            case win:
                ++userWins;
                break;
            case lose:
                ++computerWins;
                break;
            case tie:
                break;
        }
        writeln("Current score");
        writefln("You: %d", userWins);
        writefln("Computer: %d", computerWins);
    }
    if (userWins > computerWins)
        return MatchOutcome.win;
    else if (computerWins > userWins)
        return MatchOutcome.lose;
    else
        return MatchOutcome.tie;
}
/**
* Prints out an appropriate message based on how the game went.
**/
void outputWhenTheGameEnds(in MatchOutcome matchOutcome) @safe
{
    final switch (matchOutcome) with (MatchOutcome)
    {
        case win:
            writeln("Congratulations!");
            break;
        case lose:
            writeln("So sorry that you lost!");
            break;
        case tie:
            writeln("You tied...not sure how that happened.");
            break;
    }
}
bool askUserIfWantToPlayAgain()
{
    writeln("Play again? [y|n]");
    immutable choice = readln.strip.toLower;
    if (choice == "y")
        return true;
    else if (choice == "n")
        return false;
    else
    {
        writeln("Only 'y' and 'n' are acceptable answers.");
        return askUserIfWantToPlayAgain();
    }
}
void tryPlayGameLoop(in ubyte numberOfWinsRequired)
{
    try
    {
        do
        {
            immutable result = playRockPaperScissors(numberOfWinsRequired);
            outputWhenTheGameEnds(result);
        } while (askUserIfWantToPlayAgain());
    }
    catch (ExitException e) { }
}
int main(string[] argv)
{
    ubyte numberOfWinsRequired = 3;
    auto helpInformation = getopt(argv, "numberOfWinsRequired|n", 
        "The number of times the user or computer needs to win.", &numberOfWinsRequired);
    if (helpInformation.helpWanted)
        defaultGetoptPrinter("Information about rock, paper, scissors.", helpInformation.options);
    else
        tryPlayGameLoop(numberOfWinsRequired);

    return 0;
}

class ExitException : Exception 
{
    this(string file = __FILE__, size_t line = __LINE__) @safe pure nothrow
    {
        super("Exit", file, line);
    }
}