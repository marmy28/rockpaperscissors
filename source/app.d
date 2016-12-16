import views.mainwindow;
import gio.Application : GioApplication = Application;
import gtk.Application;

int main(string[] args)
{
    auto application = new Application("org.gtkd.rockpaperscissors.mainwindow", GApplicationFlags.FLAGS_NONE);
    application.addOnActivate(delegate void(GioApplication app) { new MainWindow(application);});
    return application.run(args);
}