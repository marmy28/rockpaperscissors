module views.rpsdialog;

public import gtk.Dialog;
private import gtk.Window;
private import std.conv : to;
private import gtkc.gtktypes : GtkResponseType;
private import gtk.MessageDialog : GtkDialogFlags;
public import models.enumsandresults;
private import std.algorithm.iteration;
private import std.array;
private import std.traits : EnumMembers;

public class RpsDialog : Dialog
{
    public this(Window parent)
    {
        super("Hello", parent, GtkDialogFlags.MODAL, getStringArray(), getResponseType());
    }
    private static string[] getStringArray()
    {
        return [EnumMembers!GameChoices].map!(a => a.to!string)().array();
    }
    private static GtkResponseType[] getResponseType()
    {
        return [EnumMembers!GameChoices].map!(a => a.to!GtkResponseType)().array();
    }
    public GameChoices showDialog()
    {
        return this.run().to!GameChoices;
    }
}