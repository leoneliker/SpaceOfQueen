import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim soundengine;
AudioSample sonido1, sonido2, sonido3, sonido4,sonido5,sonido6,sonido7;

PImage vidaextra,variable1,variable2,variable5,variableMeteorito, variableFondoMenu, variableBotonStart, variableDisparoNave,variableDisparoEnemigo,variableNave,variableNave2,variableNave3,variableEnemigo1,variableEnemigo2,variableEnemigo3, variableFondo, variableTiempo, variableExplosion,variableVictoria,variableDerrota,variableVidas1,variableVidas2,variableVidas3,variableNegro;
int x1,x2,a, x, y, i, j, z, e=0, t=0, q=150, p=250, s=7200, P=40,positionButtonH = 20, positionButtonW = 50,positionButtonX = 450, positionButtonY = 450,puntos=0, sentidoX, sentidoY,x_DisparoNave, y_DisparoNave,x_Nave, y_Nave,velocidadMeteorito=100,velocidadDisparoNave=3,velocidadDisparoEnemigo=8,velocidadDisparoEnemigo2=5,vidas=3, Muertos;
float x_vida=random(50,850),y_vida=0,x_Meteorito=random(200,700), y_Meteorito, x_DisparoEnemigo, y_DisparoEnemigo, x_DisparoEnemigo2, y_DisparoEnemigo2,m=55;
float[] x_Enemigo, y_Enemigo, velocidadEnemigo;
boolean[] enemigoMuerto;  
boolean vidasumada=false,boolButton=false, boolButton2=false,disparandoNave=false, disparandoEnemigo=false,disparandoEnemigo2=false, Juego;
int[]  tipoEnemigo, direccionEnemigo, contadorEnemigo, topeEnemigo;
static int[] l;

void setup() {
  //musica
  soundengine = new Minim(this);
  sonido1 = soundengine.loadSample("disparo.wav", 1024);
  sonido2 = soundengine.loadSample("musicaInicio.mp3",1024);
  sonido3 = soundengine.loadSample("musicaFondo.mp3", 1024); 
  sonido4 = soundengine.loadSample("musicaVictoria.mp3", 1024); 
  sonido5 = soundengine.loadSample("musicaDerrota.mp3", 1024);
  sonido6 = soundengine.loadSample("musicaTiempo.mp3", 1024);
  sonido7 = soundengine.loadSample("vidaextra.mp3", 1024);
  sonido2.trigger();
  //pantalla
  size(900,506);
  imageMode(CENTER);
  fill(255);
  //imagenes
  vidaextra= loadImage("vidaextra.png");
  variableMeteorito= loadImage("meteorito.png");
  variableFondoMenu = loadImage("menú.png");
  variableBotonStart = loadImage("playbutton.png"); 
  variableNave = loadImage("nave.png");
  variableNave2 = loadImage("nave2.png");
  variableNave3 = loadImage("nave3.png");
  variableDisparoNave = loadImage("disparo.png");
  variableDisparoEnemigo = loadImage("disparoenemigo.png");
  variableEnemigo1= loadImage("ovni1.png"); //Asigna a la variable enemigo una imagen externa
  variableEnemigo2= loadImage("ovni2.png"); 
  variableEnemigo3= loadImage("ovni3.png"); 
  variableFondo= loadImage("galaxia.jpg"); //Asigna a la variable fondo una imagen externa
  variableVictoria= loadImage("Victoria.jpg");
  variableTiempo= loadImage("tiempo.jpg");
  variableDerrota= loadImage("Derrota.jpg");
  variableNegro= loadImage("negro.jpg");
  variableExplosion= loadImage("Explosión.png");
  variableVidas3= loadImage("vidas3.png");
  variableVidas2= loadImage("vidas2.png");
  variableVidas1= loadImage("vidas1.png");
  variable1= loadImage("1.png");
  variable2= loadImage("2.png");
  variable5= loadImage("5.png");
  vidaextra.resize(80,40);
  variableFondo.resize(1350,1012);
  variableMeteorito.resize(100,100);
  variableBotonStart.resize(100,100);
  variableEnemigo1.resize(50,50); //Define el tamaño de la nave
  variableEnemigo2.resize(150,150);
  variableEnemigo3.resize(50,50);
  variableDisparoNave.resize(30,30);
  variableDisparoEnemigo.resize(30,30);
  variableNave.resize(50,50);
  variableNave2.resize(50,50);
  variableNave3.resize(50,50);
  variableExplosion.resize(50,50);
  variableVidas3.resize(120,50);
  variableVidas2.resize(120,50);
  variableVidas1.resize(120,50);
  variableDerrota.resize(506,506);
  variableNegro.resize(900,506);
  variableTiempo.resize(900,506);
  variableFondoMenu.resize(1550,752);
  //scroll
  x1=width/2;
  x2=x1+width;
  //posicion nave inicial
  x_Nave = int(width/2); 
  y_Nave = height-50;
  
  //enemigos
  y_Meteorito=-50;
  x_Enemigo = new float[15]; y_Enemigo = new float[15];
  velocidadEnemigo = new float[15];
  enemigoMuerto = new boolean[15];
  tipoEnemigo = new int[15];
  direccionEnemigo = new int[15];
  contadorEnemigo = new int[15];
  topeEnemigo = new int[15];
   for (int n=0;n<3;n++){
     y_Enemigo[0+n]=q;
     y_Enemigo[3+n]=p;
     y_Enemigo[6+n]=q;
     y_Enemigo[9+n]=p;
     y_Enemigo[12+n]=q;
     q=q+50;
     p=p-50;
    }
    
  for (int i=0;i<15;i++) {
    enemigoMuerto[i]=false;
    x_Enemigo[i] = m; 
    velocidadEnemigo[i] = random(500)+100;
    tipoEnemigo[i] = i % 3;
    contadorEnemigo[i] = 0;
    topeEnemigo[i] = 0;
    direccionEnemigo[i] = 0;
    m=m+55;
  }
}

void draw() {
  if(Juego==true){
    if (puntos<P && vidas>0) {
      gameplay();
      //victoria/derrota/tiempo
        if (puntos>=P && vidas>0){
          image(variableVictoria, width/2, height/2);
          noLoop();
          sonido4.trigger();
        }
        if(vidas <= 0){
          image(variableNegro, width/2, height/2);
          image(variableDerrota, width/2, height/2);
          noLoop();
          sonido5.trigger();
        }
        if(t==0 && s==0){
          image(variableTiempo, width/2, height/2);
          noLoop();
          sonido6.trigger();
          Juego=false;
        }
   }
  } else {
    inicio();
  }
}
void inicio(){
    image(variableFondoMenu, width/2, height/2);
    image(variableBotonStart, 450, 450);
    if(((mouseX < positionButtonX + positionButtonW) && (mouseX > positionButtonX - positionButtonW) && (mouseY < positionButtonY+positionButtonH) && (mouseY > positionButtonY-positionButtonH))){
      boolButton = true; 
    } else {
      boolButton = false;
    }
}
void gameplay() {
  image(variableFondo,width/2,x1);
  image(variableFondo,width/2,x2);
  x1=x1-1;
  x2=x2-1;
  if (x1<-width/2) {
    x1=x2+width;
  } else if (x2<-width/2) {
    x2=x1+width;
  }
  textSize(20);
  text("Puntos:"+puntos,(width/2)-80,30);
      tiempo();
      Meteorito();
      MovimientoNave();
      VidaNave();
      VidaExtra();
      MovimientoEnemigos();       
      DisparoNaveEnemiga();
      DisparoNave();
    if ((puntos>=P && vidas==1) || (puntos>=P && vidas==2) || (puntos>=P && vidas==3) || vidas<=0 || (t==0 && s==0)){
        sonido3.close();
    }  
}
void tiempo(){
  if (s<=480){
    textSize(100);
    s=s-1;
         fill(225,0,0); 
         text(s/60,(width/2)-50, height/2);
       }
   if (s>=480){
        textSize(30);
        s=s-1;
        text(s/60,20,40);
      } 
}
void VidaNave(){
   if ((sqrt(sq(x_Nave-x_DisparoEnemigo)+sq(y_Nave-y_DisparoEnemigo))<25) || (sqrt(sq(x_Nave-x_DisparoEnemigo2)+sq(y_Nave-y_DisparoEnemigo2))<25)) {
      vidas=vidas-1;
    }
    if (sqrt(sq(x_Nave-x_Meteorito)+sq(y_Nave-y_Meteorito))<50){
      vidas=vidas-1;
      vidas=vidas-1;
      vidas=vidas-1;
      variableExplosion.resize(900,506);
      image(variableExplosion,width/2, height/2);
    }
    if (vidas==3){
      image(variableVidas3, 800, 50);
    } else if (vidas==2){
      image(variableVidas2, 800, 50);
    } else if (vidas==1){
      image(variableVidas1,800, 50);
    } 
}
void VidaExtra(){
  if (vidas<=2 && puntos>=20 && vidasumada==false){
    y_vida=y_vida+5;
    image (vidaextra,x_vida,y_vida);
  }
  if (sqrt(sq(x_Nave-x_vida)+sq(y_Nave-y_vida))<25){
    x_vida=-100;
    y_vida=-100;
    sonido7.trigger();
    vidas=vidas+1;
    vidasumada=true;
  }
}
void MovimientoNave(){
  j=int(sqrt(sq(mouseX-x_Nave)))*1/20;
      if (mouseX<x_Nave) {
        x_Nave=x_Nave-j;
      } else if (mouseX>x_Nave) {
        x_Nave=x_Nave+j;
      }
      if (vidas==3){
      image(variableNave, x_Nave, y_Nave);
}
      if (vidas==2){
      image(variableNave2, x_Nave, y_Nave);
}
      if (vidas==1){
      image(variableNave3, x_Nave, y_Nave);
}
}
void Meteorito() {
  if (s<=4800) {
         x_Meteorito = x_Meteorito + 2*(x_Nave-x_Meteorito)/velocidadMeteorito;
         y_Meteorito = y_Meteorito + (1000-y_Meteorito)/velocidadMeteorito;

      }
      image(variableMeteorito, x_Meteorito, y_Meteorito);    
  } 
void DisparoNaveEnemiga(){
    if (disparandoEnemigo==false || (sqrt(sq(x_Nave-x_DisparoEnemigo)+sq(y_Nave-y_DisparoEnemigo))<25)) {  
       if (x_DisparoEnemigo>0){
      sonido1.trigger();
       }
      disparandoEnemigo=true;
       float i=round(random(14)); 
        x_DisparoEnemigo=x_Enemigo[round(i)];
        y_DisparoEnemigo=y_Enemigo[round(i)];
      
       }
        if (y_DisparoEnemigo>height){
          disparandoEnemigo=false;
         }
      if (disparandoEnemigo==true ) {
       y_DisparoEnemigo=y_DisparoEnemigo+velocidadDisparoEnemigo;
      image(variableDisparoEnemigo, x_DisparoEnemigo, y_DisparoEnemigo);
    }
  }                               
void mousePressed() {
  if (Juego==true && disparandoNave==false) {
      disparandoNave=true;
      sonido1.trigger();
      x_DisparoNave=x_Nave;
      y_DisparoNave=y_Nave;
  }
  if (boolButton == true && Juego == false) {
    Juego=true; 
    sonido2.close();
    sonido3.trigger();
  }
}
  void DisparoNave(){
  if (disparandoNave==true ) {
      y_DisparoNave=y_DisparoNave-velocidadDisparoNave;
      //Si las coordenadas del disparo se salen de la pantalla...
      if (y_DisparoNave<0 || (sqrt(sq(x_Enemigo[i]-x_DisparoNave)+sq(y_Enemigo[i]-y_DisparoNave))<25)) {
        disparandoNave=false;
        e=0;
      }
      image(variableDisparoNave, x_DisparoNave, y_DisparoNave);
    }
}
void MovimientoEnemigos(){
  for (int i=0;i<15;i++) {
        contadorEnemigo[i] = contadorEnemigo[i] + 1;
        if (contadorEnemigo[i]>topeEnemigo[i] || x_Enemigo[i]>width-50 || y_Enemigo[i]>height-150 || x_Enemigo[i]<width-850 || y_Enemigo[i]<height-450)  {
          direccionEnemigo[i]=int(random(4)); 
          topeEnemigo[i]=int(random(100)); 
          contadorEnemigo[i]=0; 
        }
        if (x_Enemigo[i]==width-50){
          x_Enemigo[i]=x_Enemigo[i]-1;
        } else if (y_Enemigo[i]==height-150){
          y_Enemigo[i]=y_Enemigo[i]-1;
        } else if (x_Enemigo[i]==width-850){
          x_Enemigo[i]=x_Enemigo[i]+1;
        } else if (y_Enemigo[i]==height-450){
          y_Enemigo[i]=y_Enemigo[i]+1;
        } else if (direccionEnemigo[i]==0) {
          x_Enemigo[i] = x_Enemigo[i] + 1;
        } else if (direccionEnemigo[i]==1) {
          x_Enemigo[i] = x_Enemigo[i] - 1;
        } else if (direccionEnemigo[i]==2) {
          y_Enemigo[i] = y_Enemigo[i] + 1;
        } else {
          y_Enemigo[i] = y_Enemigo[i] - 1;
        }
        if (enemigoMuerto[i]==false) {
          if (tipoEnemigo[i]==0){
            image(variableEnemigo1, int(x_Enemigo[i]), int(y_Enemigo[i]));
          if (sqrt(sq(x_Enemigo[i]-x_DisparoNave)+sq(y_Enemigo[i]-y_DisparoNave))<25) { 
            enemigoMuerto[i]=true;
            y_DisparoNave=-1000;
            puntos = puntos + 1;
            Muertos=Muertos+1;
              }
          }    
          if (tipoEnemigo[i]==1){
            image(variableEnemigo2, int(x_Enemigo[i]), int(y_Enemigo[i]));
            if (sqrt(sq(x_Enemigo[i]-x_DisparoNave)+sq(y_Enemigo[i]-y_DisparoNave))<25) { 
              enemigoMuerto[i]=true;
              y_DisparoNave=-1000;
              puntos = puntos + 2; 
              Muertos=Muertos+1;
            }
          }
          if (tipoEnemigo[i]==2){
            image(variableEnemigo3, int(x_Enemigo[i]), int(y_Enemigo[i]));
              if (sqrt(sq(x_Enemigo[i]-x_DisparoNave)+sq(y_Enemigo[i]-y_DisparoNave))<25) { 
                enemigoMuerto[i]=true;
                y_DisparoNave=-1000;
                puntos = puntos + 5; 
                Muertos=Muertos+1;
              }
          }
      } else {
        if (e<=20 && x_Enemigo[i]!=-1450 && y_Enemigo[i]!=height-10){
        e=e+1;
        textSize(10);
        image(variableExplosion,x_Enemigo[i],y_Enemigo[i]);
        if (tipoEnemigo[i]==0){
         image(variable1,x_Enemigo[i]+15,y_Enemigo[i]-15); 
        }
        if (tipoEnemigo[i]==1){
         image(variable2,x_Enemigo[i]+15,y_Enemigo[i]-15); 
        }
        if (tipoEnemigo[i]==2){
         image(variable5,x_Enemigo[i]+15,y_Enemigo[i]-15); 
        }
        
      } else{
       x_Enemigo[i]=-1450;
       y_Enemigo[i]=height-10;
      }
      }
    }
}
