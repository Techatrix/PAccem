#PAccem

##Klassenübersicht

###PAccem/PApplet
PApplet ist eine Klasse in welcher sowohl eine main, als auch eine loop funktion enthalten ist.
Sie repräsentiert die Höchste Klassen für den Programmierer.
Jegliche Maus und Tastatur Events werden in dieser Klassen übergegeben und ggf. verarbeitet.

####Variablen 
ApplicationManager am:	Verwaltet Programmelemente, wie Titel, Fenstergröße und Programmstart

Settings st: Lädt und speicher alle im Programm enthaltenen Einstellungen ab.

LanguageManager lg:	Lädt die aktuelle Sprachdatei und gibt deren Daten wieder.(siehe: data/assets/lang/)

RoomManager rm:	

DataManager dm: Verwaltet alle daten, wie 3D Modelle, Bilder, usw.

Overlay ov:	Enthält das GUI

InstructionManager im: Stillgelegt

PGraphics pg: Grafikoberfläche für 3D-Grafik

PFont font: Die aktuelle Schriftart

boolean usegl: ob die usegl einstellung zum Programmstartzeitpunkt an oder aus war.

boolean allowcgol: ?

ArrayList<String> toovmessages:	enthält alle Nachrichten die an die Konsole gesendet werden sollen. (siehe: Overlay)

PShader blurshader: Ein Shader welcher Gaussian Blur Effekt enthält. (siehe: data/assets/shader/blur.glsl)

int[] c:	Ein Array aus Farbwerten welche sich nach dem Dunkelmodus ausrichten.

boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT: Status der einzelnen Tasten

####Funktionen 
void settings(): Wird ausgeführt bevor das Programmfenster erstellt wird.

void setup(): Wird ausgeführt nachdem das Programmfenster erstellt wurde.

void draw(): Wird für jedes Bild ausgeführt. (60hz)

void mouseWheel(MouseEvent e): Wird ausgeführt, wenn der Nutzer sein Mausrad dreht.

void mouseDragged(): Wird ausgeführt, wenn der Nutzer seine Maus bewegt.

void mouseReleased(): Wird ausgeführt, wenn der Nutzer eine Maustaste loslässt.

void mousePressed(): Wird ausgeführt, wenn der Nutzer eine Maustaste drückt.

void keyPressed(KeyEvent e): Wird ausgeführt, wenn der Nutzer eine Tastaturtaste drückt.

void keyReleased(): Wird ausgeführt, wenn der Nutzer eine Tastaturtaste loslässt.

###ApplicationManager
####Variablen 
String setfontrawinput: Wird vom Thread in setfontraw() als Parameter genutzt

####Funktionen 
void initsettings(): Wird ausgeführt bevor das Programmfenster erstellt wird

void initsetup(): Wird ausgeführt nachdem das Programmfenster erstellt wurde

void settitle(String name): Legt den Programmfenstertitel fest

void setfont(String newfontname): Legt die aktuelle Schriftart fest. Es wird ermittelt ob es sich bei der gewählten Schriftart um eine aus der Roboto Schriftfamilie handelt und wenn dies nicht der Fall ist, wird setfontraw() als Thread ausgeführt, um die Schriftart zu ermitteln

void setfontraw(): Wird von setfont(String newfontname) als Thread ausgeführt.

void recalculatecolor(): Legt die Farbwerte in PAccem/PApplet gegeben nach dem Dunkelmodus fest

void loop(): Wird für jedes Bild ausgeführt. (60hz) Es wird nachgesehen ob sich die Programmfenstergröße geändert hat und daraufhin die Fenstergrößeneinstellungen angepasst und ggf. die Größe der 3D-Grafikoberfläche(pg) angepasst.

###DataManager
####Variablen 
final PImage[] icons: Liste aller Icons

final FurnitureData[] furnitures: Liste Möbel welche der Nutzer verwenden kann.

final PrefabData[] prefabs: Liste aller Fertigteile welcher der Nutzer verwenden kann.

####Funktionen 
DataManager(): initializiert alle Variablen.(siehe: data/assets/)

int[] validate(): Sieht nach, ob alle Möbel in ihren Fertigteile ins Fertigteil hineinpassen.

boolean validateid(int id): Sieht nach, ob ein Möbelstück mit der gegebenen id existiert.

FurnitureData getfurnituredata(int id): gibt die Möbelinformationen mit der gegebenen id.

PrefabData getprefabdata(int id): gibt die Fertigteilinformationen mit der gegebenen id.

####Extra
TODO
#####FurnitureData
#####PrefabData

###Furniture
####Variablen 
int id: id des Möbelstücks

int price: Preis des Möbelstücks

color tint: Farbung des Möbelstücks

####Funktionen 

void draw(boolean viewmode, boolean selected): Zeichnet/Rendert das Möbelstück

void drawframe(boolean selected) { Zeichnet/Rendert die Box auf dem Möbelstücks

boolean checkover(): Ermittelt ob die Maus auf das Möbelstück zeigt

boolean checkover(int xpos, int ypos): Ermittelt ob das Möbelstück in der gegebenen Gitterposition liegt

boolean setxpos(int value): Legt die x position des Möbelstücks fest

boolean setypos(int value): Legt die y position des Möbelstücks fest

void move(int dx, int dy): Bewegt das Möbestückt

###Grid
####Variablen 
GridTile[][] tiles: 2 dimensionales Gitter

ArrayList<RoomGroup> roomgroups: Liste aller Raumgruppen

####Funktionen 
void draw(boolean viewmode, float gts): Zeichnet/Rendert das Gitter

void filltool(boolean value, int x, int y): Wendet das Füll Werkzeug an

boolean settilestate(boolean value, int x, int y): Legt den Status des gegebenen Kachels fest
boolean gettilestate(int x, int y): Gibt den Status des gegebenen Kachels zurück

boolean settile(GridTile value, int x, int y) { Legt die Variablen des gegebenen Kachels fest
GridTile gettile(int x, int y):  Gibt die Variablen des gegebenen Kachels zurück

boolean isingrid(int x, int y):  Ermittelt ob die gegebene Position im Gitter liegt

boolean isroomgroupinuse(int id):  Ermittelt ob eine gegebene Raumgruppe im Gitter verwendet wird

void removeroomgroup(int id):  Entfernt eine gegebene Raumgruppe aus der Liste

void cgol(): hmmmm?

int getprice(): Gibt den Preis des Gitters wieder

####Extra
TODO
#####RoomGroup
#####GridTile

###InstructionManager
TODO

####Variablen 
####Funktionen 
###LanguageManager
####Variablen 
JSONObject data:  Aktuelle Sprachdaten

####Funktionen 
boolean setlang(String newlang):  legt die aktuelle Sprache fest

String get(String key) { Gebe die Übersetung mit dem gegebenen Schlüsselwort

###Overlay
####Variablen
Object[] items: Liste aller Elemente im Overlay

boolean visible: Sichtbarkeitsstatus des Overlays

final int xoff: Wird verwendet um das Gitter am Overlay auszurichten

final int yoff: Wird verwendet um das Gitter am Overlay auszurichten

final color cc: TODO

boolean drawpopup: Sichtbarkeitsstatus des Popups

int tabid: wird von Tabbar verwendet (siehe: OTabbar.pde)

String newroomname: Der Name für einen neuen Raum

int newroomxsize, newroomysize: Die Größe für einen neuen Raum

Object tempdata: temporäre Variable mit verschiedenen Verwendungen(meisten zum transfer von Daten mit dem Popup)

ArrayList<String> messages: Alle Nachrichten welche in der Nachrichten Box sind

int consoleoff: Offset der Nachrichten (scrollen)

boolean drawconsole: Sichtbarkeitsstatus der Nachrichten Box

final int messageboxheight: Höhe der Nachrichten Box

####Funktionen 
void build(): Erstellt das Overlay
void draw(): Zeichnet/Rendert das Overlay
boolean ishit(): Ermittelt ob die Maus auf dem Overlay liegt

void mouseWheel(MouseEvent e): Wird ausgeführt, wenn der Nutzer sein Mausrad dreht.

boolean mousePressed(): Wird ausgeführt, wenn der Nutzer eine Maustaste drückt und gibt zurück, ob der Click etwas im Overlay ausgelöst hat

void mouseReleased(): Wird ausgeführt, wenn der Nutzer eine Maustaste loslässt.

boolean mouseDragged(): Wird ausgeführt, wenn der Nutzer seine Maus bewegt und gibt zurück, ob die Bewegung etwas im Overlay ausgelöst hat

void keyPressed(KeyEvent e): Wird ausgeführt, wenn der Nutzer eine Tastaturtaste drückt.

void keyReleased(): Wird ausgeführt, wenn der Nutzer eine Tastaturtaste loslässt.

void requirerestart(): Öffnet das "Benötig Neustart" Popup

void checkmessages(): Fügt alle Nachrichten in toovmessages (siehe: PAccem/PApplet) der Nachrichten Box hinzu

void printmessage(String text): Fügt eine Nachricht der Nachrichten Box hinzu

void drawpopup(int id): Öffnet ein Popup (unterschiedlich je nach id)

###RoomManager
####Variablen
ArrayList<Furniture> furnitures: Liste aller Möbel im Raum

Grid roomgrid: Das aktuelle Raumgitter

int selectionid: der Index des aktuell ausgewählten Möbelstücks (-1 = kein)

String name: Name des Raums

float xoff, yoff, scale: Variablen für die 2D Ansicht

float dxoff, dyoff, dzoff, angle1, angle2, dspeed: Variablen für die 3D Ansicht

int gridtilesize: Größe eines Kachels

int tool: id des aktuell gewählten Werkzeuges

ID | Werkzeug
-- | --
0  | Bewegen
1  | Zeichnen
2  | Möbel oder Fertigteil platzieren
3  | Möbelstück auswählen
4  | Füll Werkzeug
5  | Fenster Platzieren

boolean viewmode: Wahr = 3D Ansicht , Falsch = 2D Ansicht

ArrayList<int[]> dragtiles: Liste aller Kachel über welche der Nutzer bereits gezeichnet hat.

boolean dragstate: Zeichenstatus

int newfurnitureid = 0: id von neu Platzierten Möbelstücken

int newroomgroup: id der aktuell ausgewählten Raumgruppe zum zeichnen

boolean isprefab: ob gerade eine Fertigteil platziert wird

color furnituretint: Färbung von neu Platzierten Möbelstücken

####Funktionen 
###Settings
####Variablen
####Funktionen 
###Extra 
####Baseclasses
####Basefunctions
####Constants
###Overlay Elemente 
####OBase
####OContainer
####ODynamic
####OEventDetector
####OGridView
####OImage
####OListView
####OPopup
####OSizedbox
####OSlider
####OTabbar
####OText
####OTransform 
####OVisible
