module models.enumsandresults;

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
public enum GameChoices : ubyte
{
    rock,
    paper,
    scissors
}
public enum MatchOutcome : ubyte
{
    win,
    lose,
    tie
}
/**
* Looks at both the users choice and the computers choice to determine the matches outcome.
**/
public MatchOutcome getResult(in GameChoices userChoice, in GameChoices computerChoice) nothrow pure @safe @nogc
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