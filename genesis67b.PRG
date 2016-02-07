Program Genesis67;
global
width=64;
mheight=64;
file1;
set=0;
screenswide = 1;
screensdeep = 1;
group=0;
number=0;
string cursx;
string wide;
string deep;
string fuck;
string currenttilesize;
string currentvalue;
c=0;
t$="";
count=0;
blankcol=0;
hardcol=0;
hardmap=0;
pixelcolor=0;
canvass=0;
mybutton=0;
mypointer=0;
maxsprites=5000;
cursorid;
gmod=0;
textid2=0;
textid3=0;
textid4=0;

mygroup=0;
myvalue=0;
myanimframes=5;
currentgraph=2;
tilesize=0;
mapsizex=1000;
mapsizey=1000;
struct tiles[5000]
    xpos;
    ypos;
    gfx;
    ang;
    group;
    value;
    mode;
    animframes;
    screenswidth;
    screensheight;
end
struct delete[5000]
    state = 0;
end
private
my_ident;
font1;
font2;
Begin
    set_mode(m800x600);
    file1=load_fpg("fuck.fpg");
    font1=load_fnt("myfont2.FNT");
    font2=load_fnt("myfont3.FNT");
    wide="screens wide = " + itoa(screenswide);
    deep="screens deep = " + itoa(screensdeep);

    message2(280,25,"Map Settings",font2,textid2);
    message2(260,125,wide,font1,textid3);
    message2(260,200,deep,font1,textid4);


    choose();
    repeat
        frame();
    until(set==1)
    delete_text(textid2);
    let_me_alone();
   // if(set==1)
   tiles[0].screenswidth=screenswide;
   tiles[0].screensheight=screensdeep;
    mapsizex=64*12*screenswide;
    mapsizey=64*10*screensdeep;

    canvass=new_map(mapsizex,mapsizey,mapsizex/2,mapsizey/2,0);
    hardmap=new_map(mapsizex/2,mapsizey/2,mapsizex/4,mapsizey/4,0);
    define_region(1, 0, 0, 800, 600);
    start_scroll(0,0,canvass,0,1,0);
    cursorid=cursor();
    scroll.camera=cursorid;
    write(0,0,0,0, cursx);
    write(0,0,100,0, fuck);
    write(0,0,120,0, currentvalue);
    //write_int(0,0,160,0, pdist);
    ctype=c_scroll;
    loop
        //mouse.graph=2;
        roll_palette(16, 23, 1);
        //roll_palette(208, 215, 1);
        frame(25);

    end
end
//
process cursor()
private
p=0;
n=0;
found=0;
index=0;
tick=0;
rightboundary=6336;
bottomboundary= 7616;
Begin
    region=0;
    ctype=c_scroll;
    x=width;
    y=mheight;
    graph=2;
    tick=0;
    blankcol=map_get_pixel(file1,3,1,1);
    loop
        graph=currentgraph;
        cursx = "Cursor X/Y (" + itoa(x) + "," + itoa(y) + ").";
        fuck = "mode = " + itoa(gmod) +" --  0 = map mode : 1 = process mode";
        currentvalue="Value = " + itoa(myvalue);
        tick++;
        if (tick>1)
        tick=0;
        end
        if (tick==0)
        if(key(_t))
            tilesize++;
            if (tilesize>1)
                tilesize=0;
            end
            switch(tilesize)
                case 0;
                    width=64;
                    mheight=64;
                end
                case 1;
                    width=32;
                    mheight=32;
                end
            end

        end
        if(key(_F2))
            save("level.dat",offset tiles,sizeof(tiles));

            message("Level Saved!");
        end
        if(key(_F1))
            load_level();
        end
        c++;
        if(key(_left)&&x>width)
            x-=width;
        end
        if(key(_right))
            x+=width;
        end
        if(key(_up)&&y>mheight)
            y-=mheight;
        end
        if(key(_down) && y<bottomboundary)
            y+=mheight;
        end
        if (key(_m))
            gmod++;
            if (gmod>1)
                gmod=0;
            end
        end
        if (key(_h))
            currentgraph++;
            graph=currentgraph;
        end
        if (key(_g) && currentgraph>1)
            currentgraph--;
            graph=currentgraph;
        end
        pixelcolor=map_get_pixel(file1,canvass,x,y);
        if(key(_space)&&mypointer<maxsprites)
            for(n=0;n<maxsprites;n++)
                if(delete[n].state==1)
                    index=n;
                    found=1;
                    delete[n].state=0;
                    break;
                end
            end
            if (gmod==0)
                if(pixelcolor==0 or pixelcolor==blankcol)
                    mapput(x,y,currentgraph);
                end
            end
            if(gmod==1)
                make_sprite(currentgraph,x,y,myanimframes);
            end
            switch (found)
                case 0;
                    mypointer++;
                    count++;
                    tiles[mypointer].xpos=x;
                    tiles[mypointer].ypos=y;
                    tiles[mypointer].gfx=graph;
                    tiles[mypointer].ang=angle;
                    tiles[mypointer].group=mygroup;
                    tiles[mypointer].mode=gmod;
                    tiles[mypointer].value=myvalue;
                    tiles[mypointer].animframes=myanimframes;
                end
                case 1;
                    tiles[index].xpos=x;
                    tiles[index].ypos=y;
                    tiles[index].gfx=currentgraph;
                    tiles[index].ang=angle;
                    tiles[index].group=gmod;
                    tiles[index].mode=gmod;
                    tiles[index].value=myvalue;
                    tiles[index].animframes=myanimframes;
                    index=0;
                    found=0;
                end
            end
        end



        if (key(_c))
            clear_lev();
            message("Level Cleared!");
        end
        if (key(_x))
            for(n=0;n<maxsprites;n++)
                if(tiles[n].xpos==x && tiles[n].ypos==y)
                    delete[n].state=1;
                    map_xput(file1,canvass,3,x,y,0,100,0);
                    map_xput(file1,hardmap,3,x/2,y/2,0,50,0);
                    tiles[n].xpos=0;
                    tiles[n].ypos=0;
                    tiles[n].gfx=0;
                    tiles[n].ang=0;
                    tiles[n].group=0;
                    tiles[n].mode=0;
                    tiles[n].value=0;
                    tiles[n].animframes=0;
                end
            end
        end
        if(key(_l))
            myvalue++;
        end
        if(key(_k) && myvalue>0)
            myvalue--;
        end

        end
        p=0;
        refresh_scroll(0);
        frame();
   end
end
//
process clear_lev()
private
n=0;
n2=0;
begin
stop_scroll(0);
unload_map( canvass);
unload_map(hardmap);
canvass=new_map(mapsizex,mapsizey,mapsizex/2,mapsizey/2,0);
    hardmap=new_map(mapsizex/2,mapsizey/2,mapsizex/4,mapsizey/4,0);
    define_region(1, 0, 0, 800, 600);
    start_scroll(0,0,canvass,0,1,0);
clear_screen();
refresh_scroll(0);

              for(n=0;n<maxsprites;n++)
            tiles[n].xpos=0;
            tiles[n].ypos=0;
            tiles[n].gfx=0;
            tiles[n].ang=0;
            tiles[n].group=0;
            tiles[n].mode=0;
            tiles[n].value=0;
            tiles[n].animframes=0;
            delete[n].state=0;
        end

    mypointer=0;
    signal(type make_sprite,s_kill);

end
//
process message(t$)
private
textidd;
delay=0;
begin
    textidd=write(0,400,10,0,t$);
    while(delay<50)
        delay++;
        frame();
    end
    delay=0;
    delete_text(textidd);
end
process message2(x,y,t$,myfont,tid)
private
tid;
begin

tid=write(myfont,x,y,0,t$);

end
//
Process load_level()
private
n;
Begin
    clear_lev();
    load("level.dat",offset tiles);
    //draw the saved leve; ********
    for(n=0;n<maxsprites;n++)
        if(tiles[n].xpos>0)
            switch (tiles[n].mode)
                case 0;
                    mapput(tiles[n].xpos,tiles[n].ypos,tiles[n].gfx);
                    mypointer++;
                end
                case 1;
                    make_sprite(tiles[n].gfx,tiles[n].xpos,tiles[n].ypos,4);
                    mypointer++;
                end
            end
        end
    end
    message("Level loaded!");

end
//
process make_sprite(graph,x,y,tframes)
private
pdist;
t;
tframes;
oldgraph;
begin
    region=0;
    ctype=c_scroll;
    z=-512;
    oldgraph=graph;
    loop
        t++;
        if(t>=tframes)
            t=0;
            graph=oldgraph;
        end
        graph=graph+t;
        pdist=get_dist(cursorid);
        if(pdist<385)
            //xadvance(get_angle(cursorid),2);
        end
        frame(30);
    end
end
//
Process mapput(x,y,gfx)
begin
    z=512;
    map_xput(file1,canvass,gfx,x,y,0,100,0);
    map_xput(file1,hardmap,5,x/2,y/2,0,50,0);

end

process choose()
private
tick=0;
begin
    mybutton=make_button(15,1,630,150,200) ;
    mybutton=make_button(16,2,190,150,200) ;
    mybutton=make_button(15,3,630,230,200) ;
    mybutton=make_button(16,4,190,230,200) ;

    repeat
        tick++;
        if(tick>1)
        tick=0;
        if(key(_s))
            set=1;
            break;
        end
        if(key(_left) && screenswide>1)
            screenswide--;
            wide="screens wide = " + itoa(screenswide);

        end
        if(key(_right) && screenswide<40)
            screenswide++;
            wide="screens wide = " + itoa(screenswide);

        end
        if(key(_up) && screensdeep>1)
            screensdeep--;
            deep="screens deep = " + itoa(screensdeep);

        end
        if(key(_down) && screensdeep<40)
            screensdeep++;
             deep="screens deep = " + itoa(screensdeep);

        end
        end
        frame();
    until (set==1)
end

Process make_button(graph,buttonval,x,y,size)
private
    Begin

        Loop
            frame();
        end

end