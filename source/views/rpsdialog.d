module views.rpsdialog;

public import gtk.Window;
private import std.conv : to;
private import gtkc.gtk;
private import gtk.Button;
private import gtk.HButtonBox;
private import models.enumsandresults;

public class RpsDialog : Window
{
    private GameChoices _Choice;
    public GameChoices Choice() @property
    {
        return this._Choice;
    }
    public this()
    {
        super("Choose");
        auto hButtonBox = new HButtonBox();
        foreach(GameChoices gameChoice; [EnumMembers!GameChoices])
        {
            auto b = new Button();
            b.setLabel(gameChoice.to!string);
            b.addOnClicked(delegate void(Button button) { this._Choice = gameChoice; this.close(); });
            hButtonBox.packStart(b, true, true, 3);
        }
        this.add(hButtonBox);
    }
}