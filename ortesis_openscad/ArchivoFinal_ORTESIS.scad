//Se importa una librería para colocar nombres en el sólido
use <write.scad>

//Puede escribir las siguientes opciones:
//Número 1: soporte antebrazo, Número 2: soporte mano, Número 3: mano, Número 4: soporte pulgar, Número 5: dedo   
pieza= 1;

//Puede escribir las siguientes opciones para el tipo de brazo-mano:
//derecha, izquierda
mano="derecha";
// Unidades [mm] 

// mitad de la longitud del antebrazo
forearm_length=83; //min valor 83mm

//ancho del antebrazo, generalmente es medido en la mitad de la longitud del antebrazo
forearm_width=50; //min valor 50mm



//Longitud medida desde la muñeca hasta el tope del dedo meñique
hand_length=77; //Valor min 77

//Ancho del dedo
FingerWidth = 15.5;
//Alto del dedo
FingerHeight = 13.5;
//largo del dedo
FingerLength = 23.5;
//Largo del orificio de la uña del dedo
FingerTip = 12;

//Grosor del material para los dedos, valor recomendado!!!
Thikness = 2;




ancho_forearm_p=forearm_width/50;
valor1=hand_length/1.73033707865;
valor_p=valor1/44.5;

//largo de la parte donde se coloca el nombre "ESPOL"
largo1=round(forearm_length/2.77);

//Largo de la parte que va a ir con los tornillos
largo2=forearm_length-largo1;

valor=largo2/0.95495495495;
//El desfase vertical es la distancia que se eleva el sólido ya que no es semi-circunferencia para tener un "mejor" agarre
desfase_vertical= forearm_width/5;


//********************************************************
// Código del soporte del antebrazo

// Sólido donde se coloca el nombre
module soporte_nombre(){
    difference(){
        translate([0,-largo1/2, (forearm_width+6)/2 +desfase_vertical-forearm_width/50])
        cube([forearm_width/2.5,largo1,forearm_width/25],center=true);
            
        translate([-forearm_width/5,0,(forearm_width+6)/2 +desfase_vertical-forearm_width/25])
        empalme(5,forearm_width/10,0,0,0);
            
        translate([forearm_width/5,0,(forearm_width+6)/2 +desfase_vertical-forearm_width/25])
        rotate([0,0,270])
        empalme(5,forearm_width/10,0,0,0);
    }
}

// Primer Soporte del antebrazo (donde se coloca el nombre "ESPOL")
module soporte1(){
    difference(){
        hull(){
            translate([0,0,desfase_vertical])
            rotate([90,0,0])
            cylinder(h=largo1,d=forearm_width+6,$fn=200);
                
            soporte_nombre();
        }  
        translate([0,0.5,desfase_vertical])
        rotate([90,0,0])
        cylinder(h=largo1+1,d=forearm_width,$fn=200);
            
        translate([0,-largo1/2,forearm_width/2.63])
        cube([forearm_width+20,largo1/1.5,forearm_width/1.79],center=true);
    }
    translate([forearm_width/5 -1.5,-largo1+1.5,(forearm_width+6)/2 +desfase_vertical])
    rotate([0,0,90])
    write("ESPOL",t=1,h=largo1/4);
}


// Con difference se puede hacer empalme a un solido
module empalme(radio,largo,inclinacionX,inclinacionY,inclinacionZ){
    diam=radio*2;
    scale([1.05,1.05,1.05])
    translate([radio,-radio,0])
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    linear_extrude(largo){
        difference(){
            square(diam,center=true);
            circle(d=diam,$fn=200);
            scale([1.1,1.1,1.1])
            polygon(points=[[0,radio],[radio,radio],[radio,-radio],[-radio,-radio],[-radio,0],[0,0]]);
        }
    }
}



// Empalme 2. Por el momento no se lo utiliza en este proyecto
module empalme2(diam, diam_circ){
    //Cambiar el valor 10
    translate([0,diam/2,10])
    rotate([90,0,0])
    rotate_extrude($fn=150)
    translate([diam_circ/2+diam/2,0,0])
    union(){
        polygon(points=[[0,diam/2],[diam/2,diam/2],[diam/2,-diam/2
            ],[-diam/2,-diam/2],[-diam/2,0],[0,0]]);
        circle(d=diam,$fn=150);
    }
}

// Soporte para colocar los tornillos laterales
module agarres_laterales(){
    difference(){
        translate([-(forearm_width+6)/2,0,forearm_width/10])
        cube([4,largo2,desfase_vertical]);
        translate([-(forearm_width+6)/2+2,0,forearm_width/10])
        cube([4,largo2/2,desfase_vertical]);
    }
}

// Soporte para colocar los tornillos superiores
module agarre_superior(){
    difference(){
        translate([0,largo2/2,(forearm_width+6)/2 +desfase_vertical-2.5])
        rotate([0,90,0])
        cube([5,largo2,desfase_vertical],center=true);
        translate([0,largo2/2,(forearm_width+6)/2 +desfase_vertical-5])
        rotate([0,90,0])
        cube([5,largo2,desfase_vertical],center=true);
    }
}

// Huecos para los tornillos
module huecos_tornillos(inclinacionX,inclinacionY,inclinacionZ){
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    union(){
        translate([0,0,2])
        cylinder(h=5,d=5,$fn=200);
        cylinder(h=2.1,d1=9,d2=5,$fn=200);
    }
}

// Se colocan los huecos de los tornillos en las partes laterales
module huecos_laterales(){
    translate([forearm_width/2 -0.9,largo2/6.752,desfase_vertical])
    huecos_tornillos(0,90,0);
    translate([forearm_width/2 -2.8,largo2/1.183,desfase_vertical])
    huecos_tornillos(0,90,0);
}

// Se colocan los huecos de los tornillos en la parte superior
module huecos_superiores(){
    translate([0,largo2/3.533,forearm_width/2 +desfase_vertical-1.2])
    huecos_tornillos(0,0,0);
    translate([0,largo2/1.3947,forearm_width/2 +desfase_vertical-2.3])
    huecos_tornillos(0,0,0);
}

//Segundo Soporte donde se colocan los tornillos, todas las anteriores funciones unidas
module soporte2(){
    difference(){
        union(){
            difference(){
                hull(){
                    rotate([90,0,0])
                    translate([0,desfase_vertical,-largo2/2])
                    cylinder(h=largo2,d2=forearm_width+6,d1=forearm_width+1,$fn=200, center=true);
                    agarre_superior();
                    agarres_laterales();
                    mirror([1,0,0])
                    agarres_laterales();
                }
                rotate([90,0,0])
                translate([0,desfase_vertical,-largo2/2])
                cylinder(h=largo2 +1,d2=forearm_width,d1=forearm_width-5,$fn=200, center=true);
                    
                translate([0,largo2/2,forearm_width/2.08])
                cube([forearm_width+20,largo2-9.52,forearm_width/3],center=true);   
            }
        }
        huecos_laterales();
        mirror([1,0,0])
        huecos_laterales();
        huecos_superiores();
    }
}


//Ensamble de la pieza final
module soporte_antebrazo(){
    difference(){
        union(){
            soporte1();
            soporte2();
        }
        translate([0,0,-forearm_width/5])
        cube([forearm_width+10,forearm_length+100,forearm_width/2.5],center=true); 
    }
}




//********************************************************
//Código soporte mano

module base_soporte(largo,ancho, espesor){
    scale([1,ancho_forearm_p,1])    
    translate([-largo/2,0,espesor/2])
    cube([largo,ancho,espesor],center=true);
}

module soporte_resorte(){
    union(){ 
        translate([0,0,2])
        cylinder(h=5,d=5,$fn=200);
        cylinder(h=2.1,d1=9,d2=5,$fn=200);
        translate([0,0,7])
        sphere(d=7,$fn=120);
    }
}

module soporte_tuerca(){
    rotate([0,0,90])
    union(){
        cylinder(h=2.5,d=8.5,$fn=6,center=true);
        cylinder(h=20,d=5,$fn=120,center=true);
    }
}

module empalme(radio,largo,inclinacionX,inclinacionY,inclinacionZ){
    diametro=radio*2;
    translate([0,0,-1])
    scale([1.05,1.05,1.05])
    translate([radio,-radio,0])
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    linear_extrude(largo){
        difference(){
            square(diametro,center=true);
            circle(d=diametro,$fn=200);
            scale([1.1,1.1,1.1])
            polygon(points=[[0,radio],[radio,radio],[radio,-radio],[-radio,-radio],[-radio,0],[0,0]]);
        }
    }
}

module hand_stag_straight(){
    difference(){
        union(){
            base_soporte(valor,10,5);
            translate([-valor,0,0])
            base_soporte(valor1,10,5);
            translate([-5,0,5])
            soporte_resorte();
        }
        translate([-8.4,-25,5.2])
        empalme(4,50,90,270,180);

        mirror([1,0,0])
        translate([-8.4+valor+valor1,30,1.8])
        empalme(4,50,90,90,0);

        translate([-valor/3.171428571,0,3.75])
        soporte_tuerca();
        translate([-valor/1.37037037,0,3.75])
        soporte_tuerca();

        translate([-valor-valor1/1.78,0,3.75])
        soporte_tuerca();
        translate([-valor-valor1/1.202702703,0,3.75])
        soporte_tuerca(); 
    }
}


//********************************************************
//Código mano

// Sólido de los 4 dedos
module dedo(diametro, largo,espesor,inclinacionX,inclinacionY,inclinacionZ){
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    difference(){
        union(){
            translate([0,0,espesor/2])
            cylinder(h=espesor, d=diametro,$fn=150,center=true);
            translate([largo/2,0,espesor/2])
            cube([largo,diametro,espesor],center=true);
        }
        translate([0,0,-1])
        hueco_dedo(10);
    }
}

//huecos por donde pasará el hilo en los 4 dedos
module hueco_dedo(largo){
    scale([1/valor_p,1/valor_p,1])
    translate([0,0,largo/2])
    union(){   
        translate([largo/2.35,0,0])
        cylinder(h=largo,d=3.5,center=true,$fn=120);
        translate([-largo/13,0,0])
        cylinder(h=largo,d=3.5,center=true,$fn=120);
    }
}

//base donde se colocan los dedos
module base(){
    translate([-20,1.45,2.5])
    cube([40,53,5], center=true);
}

//Realiza algunos cortes en la base para que no sea completamente rectangular
module curvaturas(){
    translate([0,0,-1])
    linear_extrude(20){
        union(){
            polygon(points=[[-42,28],[-17,18.5],[-17,28]]);
            translate([-4.5,23.5,0])
            square([25,10],center=true);
        }
    }
}

// Empalme de la base
module empalme(radio,largo,inclinacionX,inclinacionY,inclinacionZ){
    diametro=radio*2;
    translate([0,0,-1])
    scale([1.05,1.05,1.05])
    translate([radio,-radio,0])
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    linear_extrude(largo){
        difference(){
            square(diametro,center=true);
            circle(d=diametro,$fn=200);
            scale([1.1,1.1,1.1])
            polygon(points=[[0,radio],[radio,radio],[radio,-radio],[-radio,-radio],[-radio,0],[0,0]]);
        }
    }
}

// cavidades donde se colocarán los tornillos
module hueco_tornillos(inclinacionX,inclinacionY,inclinacionZ){
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    scale([1/valor_p,1/valor_p,1])
    union(){
        translate([0,0,2])
        cylinder(h=5,d=5,$fn=200);
        cylinder(h=2.1,d1=9,d2=5,$fn=200);
    }
}

module huecos_rectos(diametro, ancho, largo){
    translate([0,0,-1])
    linear_extrude(20){
        circle(d=diametro,$fn=120);    
        polygon(points=[[diametro/2,0],[diametro/2,-ancho/2],[-largo,-ancho/2],[-largo,diametro/2],[0,diametro/2],[0,0]]);
    }
}

//Tuerca para el soporte del lapiz
module tuerca(){
    scale([1/valor_p,1/valor_p,1])
    union(){
        cylinder(h=3,d=8.5,$fn=6,center=true);
        cylinder(h=20,d=5,$fn=120,center=true);
    }
}


module overhand_pieza_derecha(){
    scale([valor_p,valor_p,1])
    difference(){
        union(){
            base();
            translate([-52.7,-21.5,2])
            dedo(10,17,5,0,0,7);
            translate([-55,-5,2])
            dedo(10,19,5,0,0,0);
            translate([-52,10.5,2])
            dedo(10,16,5,0,0,-2);
            translate([-46,24,2])
            dedo(10,12,5,0,0,-18);
        }
        union(){
            translate([-36+5,0,7.6])
            cube([10,80,5], center=true);
            translate([-36,0,7.6])
            rotate([90,0,0])
            cylinder(h=80,d=5,center=true, $fn=120);
        }
        curvaturas();
        mirror([0,1,0])
        curvaturas();

        translate([-16.8,-1.7,0])
        empalme(8,10,0,0,180);
        mirror([0,1,0])
        translate([-16.8,-1.7,0])
        empalme(8,10,0,0,180);


        translate([-8,0,0])
        hueco_tornillos(0,0,0);
        translate([-20,0,0])
        hueco_tornillos(0,0,0);

        translate([-7,10,0])
        huecos_rectos(4,6,18);
        mirror([0,1,0])
        translate([-7,9.9,0])
        huecos_rectos(4,6,18);

        translate([-30,11,1.5])
        tuerca();
        mirror([0,1,0])
        translate([-30,14,1.5])
        tuerca();
    }
}

module overhand_pieza_izquierda(){
    mirror([0,1,0])
    overhand_pieza_derecha();
}


//********************************************************
//Código soporte pulgar
module soporte_tuerca_thumb(){
    union(){
        translate([0,0,2])
        cylinder(h=7,d=8.5,$fn=6,center=true);
        cylinder(h=20,d=5,$fn=120,center=true);
    }
}


// Sólido de los 4 dedos
module dedo_thumb(diametro, largo,espesor,inclinacionX,inclinacionY,inclinacionZ){
    rotate([inclinacionX,inclinacionY,inclinacionZ])
    difference(){
        union(){
            translate([0,0,espesor/2])
            cylinder(h=espesor, d=diametro,$fn=150,center=true);
            translate([largo/2,0,espesor/2])
            cube([largo,diametro,espesor],center=true);
        }
        translate([-0.25,0,-1])
        hueco_dedo_thumb(10);
    }
}

//huecos por donde pasará el hilo en los 4 dedos
module hueco_dedo_thumb(largo){
    translate([0,0,largo/2])
    union(){   
        translate([largo/2.35,0,0])
        cylinder(h=largo,d=3.5,center=true,$fn=120);
        translate([-largo/13,0,0])
        cylinder(h=largo,d=3.5,center=true,$fn=120);
    }
}

module base_thumb(largo, ancho, espesor){
    cube([largo,ancho,espesor]);
}

module relleno(){
    linear_extrude(desfase_vertical)
    /*polygon(points=[[-0.16981*largo2+30.6,4],[27,4],[35.1,13]]);
    polygon(points=[[-0.16981*largo2+30.6,4],[27,4],[41.2,18.6]]);*/
    polygon(points=[[-0.16981*largo2+30.6,4],[27,4],[0.26521*hand_length+14.67826,hand_length*(0.24347) -5.74782]]);

}

module soporte_thumb(){
    difference(){
        translate([-largo2/2,desfase_vertical/2,0.2])
        rotate([90,0,0])
        union(){
            translate([-largo2/2,-0.2,0])
            //cambiar el valor de 10
            base_thumb(largo2,5,desfase_vertical);
            //translate([0.49528*largo2-52.75,0,0.5*desfase_vertical-5])
            translate([0.49528*largo2-52.75 +0.32602*hand_length-25.1041,0.31575*hand_length-24.31301,0.5*desfase_vertical-5])
            union(){
                translate([75.7,26.7,5])
                rotate([90,180,0])
                //Cambiar el valor de 10
                dedo_thumb(desfase_vertical,hand_length/2.2,3.6,0,-44,0);
                translate([-0.49528*largo2+52.75-0.32602*hand_length+25.1041+0.50471*largo2-26.75,-0.31575*hand_length+24.31301,-0.5*desfase_vertical+5])
                relleno();
            }
            translate([-largo2/1.183 +largo2/1.47222,5,desfase_vertical/2])
            soporte_resorte_thumb();
        }
        translate([-largo2/6.611,0,3.5])
        soporte_tuerca_thumb();
        translate([-largo2/1.1778,0,3.5])
        soporte_tuerca_thumb();
    }
}

module soporte_resorte_thumb(){
    rotate([-90,0,0])
    union(){
        translate([-1.5,-1.5,1.75])
        cube([3,3,3]);
        rotate([0,0,45])
        cylinder(h=2,d1=9,d2=4,$fn=4);
        translate([-5.5,-1.5,4.5])
        cube([7,3,3]);
    }
}

//dedos

/*
 Crea la cascara de un dedo, solo un falange
*/
module finger(proportion_y, proportion_y2, proportion_z, proportion_z2, FingerRadius, FingerLength){
    union(){
        difference(){
            scale([1,proportion_y2])
            cylinder (r = FingerRadius+Thikness,h= FingerLength-FingerRadius*proportion_z, $fn=100);
            scale([1,proportion_y])
            cylinder (r = FingerRadius, h= FingerLength-FingerRadius*proportion_z, $fn=100);
        }
        
        //Punta del dedo
        translate([0,0,FingerLength-FingerRadius*proportion_z])
        difference(){
            //esfera hueca
            scale([1,proportion_y2,proportion_z2])
            sphere(r=FingerRadius+Thikness, $fn=100);
            scale([1,proportion_y,proportion_z])
            sphere(r=FingerRadius, $fn=100);
            //Se elimina la mitad de la esfera
            translate([0,0,-(FingerRadius+Thikness)/2])
            cube([(FingerRadius+Thikness)*2, (FingerRadius+Thikness)*2, FingerRadius+Thikness],center=true);
        }
    }
}

/*
 Hueco para la llema del dedo
*/
module hole(r_hole, FingerLength, FingerRadius){//para mi medida es de 10
    rotate([90,0,0])
    cylinder(r=r_hole, h=(FingerRadius+Thikness)*2, center=true, $fn=100);
}

//Funciones para la agarradera
module donut_border(donut_radius, inter_radius){
    union(){
        //Seccion superior
        translate([0,0,donut_radius])
        difference(){
            cylinder(h=donut_radius*2, r=donut_radius+inter_radius,center=true, $fn=100);
            
            rotate_extrude($fn=100)
            translate([donut_radius + inter_radius,0,0])
            circle(d = donut_radius*2, $fn=100);
            
            translate([0,0,-donut_radius/2])
            cube([(donut_radius+inter_radius)*2,(donut_radius+inter_radius)*2,donut_radius],center=true);
        }
        
        //Sección de la mitad
        cylinder(h=donut_radius*2, r=inter_radius,center=true, $fn=100);
        
        //Seccion inferior
        translate([0,0,-donut_radius])
        rotate([180,0,0])
        difference(){
            cylinder(h=donut_radius*2, r=donut_radius+inter_radius,center=true, $fn=100);
            
            rotate_extrude($fn=100)
            translate([donut_radius + inter_radius,0,0])
            circle(d = donut_radius*2, $fn=100);
            
            translate([0,0,-donut_radius/2])
            cube([(donut_radius+inter_radius)*2,(donut_radius+inter_radius)*2,donut_radius],center=true);
        }
    }
}

/*
 Crea el cuerpo triangular junto con lo sobresalido de 0.5mm
*/
module agarradera(proportion_z2, y, FingerLength, FingerRadius){
    ancho = 13.4;
    alto = 4.8;
    
    R = 2.75;
    r = 2.25;
    
    R_x = 5.5;//Posicion en x del circulo de la sección {Q}
    R_y = (alto-R);//Posicion en y del circulo de la sección {Q}
    
    //Cálculos iniciales
    Oo = sqrt(pow(R_x,2)+pow(R_y-r,2));
    Ti = sqrt(pow(Oo,2)-pow(R+r,2));
    theta = atan((R_y-r)/R_x);
    alpha = asin((R+r)/Oo);
    
    x = r*tan((alpha+theta)/2);
    a = (x+Ti)*sin(alpha+theta);
    b = (x+Ti)*cos(alpha+theta);
    c = R*cos(alpha-theta);
    
    h = sqrt(pow(R_y,2)+pow(ancho-R_x,2));
    gamma = atan(R_y/(ancho-R_x));
    omega = asin(R/h);
    g = R/tan(omega);
    
    f = g*sin(gamma+omega);
    e = g*cos(gamma+omega);
    d = (ancho-R_x)-x-e;
    
    //Ubicación de los puntos:
    P1 = [x,0];
    P2 = [x+b,a];
    P3 = [ancho-e,f];
    P4 = [ancho,0];
    //Gráfico de la figura
    union(){
        h_soporte = y+(FingerLength+Thikness)-(FingerRadius+Thikness)*proportion_z2*2;//desde la base hasta el borde del hueco de la uña
        //Sección triangular con los bordes redondos
        translate([h_soporte-ancho,0.5,0])
        difference(){
            translate([0,0,-Thikness])
            union(){
                //Sección {P}
                linear_extrude(Thikness*2)
                polygon(points=[P1,P2,P3,P4]);
                
                //Sección {Q}
                translate([R_x,R_y,0])
                cylinder(h=Thikness*2,r=R,$fn=100);
                
                //Sección {S}
                difference(){
                    cube([r*sin(alpha+theta),r,Thikness*2]);
                    translate([0,r,0])
                    cylinder(h=Thikness*2,r=r,$fn=100);
                }
            }
            //Elimina el excedente del un cilindro de r=R de la sección {Q}
            translate([0,-(R*2-alto),-Thikness])
            cube([ancho,R*2-alto,Thikness*2]);
            
            //Se agrega el hueco de 2mm de diámetro
            translate([R_x,alto/2,0])
            donut_border(Thikness/2, 1);
            
            //en caso de que el triangulo pase a la zona de -z, eliminamos eso
            if(h_soporte-ancho<0){
                earase = ancho-h_soporte;//medida a borrar de la agarradera
                translate([0,-Thikness,-Thikness])
                cube([earase,0.5+Thikness+alto,Thikness*2]);
            }
            
        }
        
        //Sección para el Volumen sobresalido de 0.5mm de la pieza
        translate([0,-Thikness,-Thikness])
        cube([h_soporte,0.5+Thikness,Thikness*2]);
    }
    
}

 //Extension de la pieza para soporte de la agarradera 
module extension_dedal(proportion, proportion_2, FingerLength, FingerRadius, h){
    difference(){
        //Cuerpo cilindrico de la extensión
        scale([1,proportion_2])
        cylinder (r = FingerRadius+Thikness,h= h, $fn=100);
        scale([1,proportion])
        cylinder (r = FingerRadius, h= h, $fn=100);
        
        //Se quita la mitad del cuerpo
        difference(){
            union(){
                scale([1,proportion_2])
                translate([-(FingerRadius+Thikness),0,0])
                cube([(FingerRadius+Thikness)*2,FingerRadius+Thikness,h]);
                
                //Borde redondeado del medio
                rotate([0,0,180])
                borde_redondo(FingerLength, FingerRadius);
            }
            //Borde redondeado del extremo
            translate([0,0,h])
            rotate([-90,0,0])
            borde_redondo(FingerLength, FingerRadius);
        }
        
        //ranura
        ancho_ranura = h-3;
        alto_ranura = 1.9;
        translate([0,-(FingerRadius*proportion+Thikness)/2,3+ancho_ranura/2])
        cube([(FingerRadius+Thikness)*2,alto_ranura,ancho_ranura],center=true);
    }
}

module borde_redondo(FingerLength, FingerRadius){
    translate([0,(FingerRadius+Thikness)/6,(FingerRadius+Thikness)/6])
    difference(){
        cube([(FingerRadius+Thikness)*2,(FingerRadius+Thikness)/3,(FingerRadius+Thikness)/3],center=true);
        
        translate([0,(FingerRadius+Thikness)/6,(FingerRadius+Thikness)/6])
        rotate([0,90,0])
        cylinder(h=(FingerRadius+Thikness)*2,r=(FingerRadius+Thikness)/3,$fn=100,center=true);
    }
}

/*
 Función para diseño de la pieza
*/
module draw_finger(FingerWidth, FingerHeight, FingerLength, 
FingerTip){
    FingerRadius=FingerWidth/2;
    proportion_y = FingerHeight/FingerWidth;
    //proportion_y = 1;
    proportion_y2 = (FingerRadius*proportion_y+Thikness)/(FingerRadius+Thikness);
    proportion_z = FingerTip/(FingerRadius*2);//Para que la punta del dedo tiene un radio de 'FingerTip'
    proportion_z2 = (FingerRadius*proportion_z+Thikness)/(FingerRadius+Thikness);
    y=10;
    //rotate([-90,0,0])//en esta linea se lo posiciona para imprimir 3D
    union(){
        translate([0,0,y])
        difference(){
            //Cáscara con forma de dedo
            finger(proportion_y, proportion_y2, proportion_z, proportion_z2, FingerRadius, FingerLength);
            
            //Orificio de la parte superior de la uña
            translate([0,-(FingerRadius+Thikness)*proportion_y2,(FingerLength+Thikness)-(FingerRadius+Thikness)*proportion_z2])
            scale([1,proportion_y2,proportion_z2])
            rotate([0,90,0])
            cylinder(h=(FingerRadius+Thikness)*2, r=FingerRadius+Thikness, center=true, $fn=100);
            
            translate([0,-(FingerRadius+Thikness)*proportion_y2/2,+FingerLength+(FingerRadius+Thikness)*proportion_z2/2-FingerRadius*proportion_z])
            scale([1,proportion_y2,proportion_z2])
            cube([(FingerRadius+Thikness)*2,FingerRadius+Thikness,FingerRadius+Thikness],center=true);//[x,y,z]
            
            //Hoyo de la llema del dedo
            r_hole = 6*FingerRadius/(15.5/2);//Referencial a mi dimension
            translate([0,(FingerRadius+Thikness)*proportion_y2,FingerLength-r_hole-FingerRadius*proportion_z2/2])//La parte superior del hoyo siempre queda a la mitad de la "esfera interior" de la punta del dedo
            scale([1,proportion_y2])
            hole(r_hole, FingerLength, FingerRadius);
        }
        
        extension_dedal(proportion_y, proportion_y2, FingerLength, FingerRadius,h=y);
        
        //La agarradera triangular por donde pasa el "hilo"
        translate([0,-(FingerRadius*proportion_y+Thikness),0])
        rotate([0,-90,180])
        agarradera(proportion_z2, y, FingerLength, FingerRadius);
    }
}

//********************************************************
//********************************************************

if(pieza==1){    soporte_antebrazo();
}else if(pieza==2){
    hand_stag_straight();
}
else if(pieza==3){
   if(mano=="derecha"){ overhand_pieza_derecha();}else{
    overhand_pieza_izquierda();}
}else if(pieza==4){
    rotate([90,0,0])
    soporte_thumb();
}else if(pieza==5){
    draw_finger(FingerWidth, FingerHeight, FingerLength, FingerTip);
}