module views.mainwindow;

import gtk.Application;
import gtk.ApplicationWindow;
import gtk.Label;
import gtk.VBox;
import gtk.Button;
import std.random : uniform;
import std.format;
import models.enumsandresults;
import views.rpsdialog;

public class MainWindow : ApplicationWindow
{
    private ubyte _UserScore = 0;
    private ubyte _ComputerScore = 0;
    private Label _ScoreLabel;
    this(Application application)
    {
        super(application);
        this.initUI();
        this.showAll();
    }
    private void initUI()
    {
        this.setTitle("Rock, Paper, Sissors");
        this.setBorderWidth(10);
        auto box = new VBox(false, 2);
        this._ScoreLabel = new Label("Score");
        this.updateScore();
        box.add(this._ScoreLabel);
        auto b = new Button("Play");
        b.addOnClicked(delegate void(Button button) 
        {
            auto i = new RpsDialog(this);
            scope(exit) i.destroy();
            immutable userChoice = i.showDialog();
            import std.stdio : writeln;
            if (userChoice == GameChoices.rock)
                writeln("Rock");
            immutable computerChoice = getComputerChoice();
            immutable matchResult = getResult(userChoice, computerChoice);
            this.updateScore(matchResult);
            this.updateScore();
        });
        box.add(b);
        this.add(box);
    }
    private void updateScore()
    {
        this._ScoreLabel.setLabel(format("User: %d, Computer %d", this._UserScore, this._ComputerScore));
    }
    GameChoices getComputerChoice() @safe const
    {
        return uniform!GameChoices();
    }
    private void updateScore(in MatchOutcome matchOutcome)
    {
        final switch (matchOutcome) with (MatchOutcome)
        {
            case win:
                ++this._UserScore;
                break;
            case lose:
                ++this._ComputerScore;
                break;
            case tie:
                break;
        }
    }
}