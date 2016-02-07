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
string currentlevel;
c=0;
t$="";
count=0;
mylevel=1;
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
struct level
struct tiles[5000]
    xpos;
    ypos;
    gfx;
    ang;
    group;
    value;
    mode;
    animframes;
end
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
    file1=load_fpg("genesis67/fuck.fpg");
    font1=load_fnt("genesis67/myfont2.FNT");
    font2=load_fnt("genesis67/myfont3.FNT");
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
    level.screenswidth=screenswide;
    level.screensheight=screensdeep;
    mapsizex=64*12*screenswide;
    mapsizey=64*10*screensdeep;
    canvass=new_map(mapsizex,mapsizey,mapsizex/2,mapsizey/2,0);
    hardmap=new_map(mapsizex/2,mapsizey/2,mapsizex/4,mapsizey/4,0);
    define_region(1, 0, 0, 800, 600);
    start_scroll(0,0,canvass,0,1,0);
    cursorid=cursor();
    scroll.camera=cursorid;
    write(font1,0,0,0, cursx);
    write(font1,0,70,0, fuck);
    write(font1,0,120,0, currentvalue);
    //write_int(0,0,160,0, pdist);
    //ctype=c_scroll;
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

id2;
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
        fuck = "mode = " + itoa(gmod);
        currentvalue="Value = " + itoa(myvalue);
        currentlevel="Current Level = "+itoa(mylevel);
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
            //save("level.dat",offset level,sizeof(level));
            save("level"+itoa(mylevel)+".dat",offset level, sizeof(level));

            message("Level Saved!");
        end
        if(key(_F1))
            ctype=c_screen;
            load_level();
            ctype=c_scroll;

        end
        c++;
        if(key(_left)&&x>width)
            x-=width;
        end
        if(key(_right) && x<mapsizex-width)
            x+=width;
        end
        if(key(_up)&&y>0+mheight)
            y-=mheight;
        end
        if(key(_down) && y<mapsizey-mheight)
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
                    level.tiles[mypointer].xpos=x;
                    level.tiles[mypointer].ypos=y;
                    level.tiles[mypointer].gfx=graph;
                    level.tiles[mypointer].ang=angle;
                    level.tiles[mypointer].group=mygroup;
                    level.tiles[mypointer].mode=gmod;
                    level.tiles[mypointer].value=myvalue;
                    level.tiles[mypointer].animframes=myanimframes;
                end
                case 1;
                    level.tiles[index].xpos=x;
                    level.tiles[index].ypos=y;
                    level.tiles[index].gfx=currentgraph;
                    level.tiles[index].ang=angle;
                    level.tiles[index].group=gmod;
                    level.tiles[index].mode=gmod;
                    level.tiles[index].value=myvalue;
                    level.tiles[index].animframes=myanimframes;
                    index=0;
                    found=0;
                end
            end
        end
        if (key(_c))
            ctype=c_screen;
            clear_lev();
            message("Level Cleared!");
            ctype=c_scroll;
        end
        if (key(_x))
                for(n=0;n<maxsprites;n++)
                    if(level.tiles[n].xpos==x && level.tiles[n].ypos==y)
                        delete[n].state=1;
                        switch(gmod)
                            case 0;
                                map_xput(file1,canvass,3,x,y,0,100,0);
                                map_xput(file1,hardmap,3,x/2,y/2,0,50,0);
                                level.tiles[n].xpos=0;
                                level.tiles[n].ypos=0;
                                level.tiles[n].gfx=0;
                                level.tiles[n].ang=0;
                                level.tiles[n].group=0;
                                level.tiles[n].mode=0;
                                level.tiles[n].value=0;
                                level.tiles[n].animframes=0;

                            end
                            case 1;
                                id2=collision(type make_sprite);
                                fuck=1;
                                level.tiles[n].xpos=0;
                                level.tiles[n].ypos=0;
                                level.tiles[n].gfx=0;
                                level.tiles[n].ang=0;
                                level.tiles[n].group=0;
                                level.tiles[n].mode=0;
                                level.tiles[n].value=0;
                                level.tiles[n].animframes=0;
                                break;
                            end
                        end
                     end
                end
                if (fuck==1)
                    fuck=0;
                    signal (id2,s_kill);
                end
       //end
        if(key(_l))
            myvalue++;
        end
        if(key(_k) && myvalue>0)
            myvalue--;
        end
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
    unload_map(canvass);
    unload_map(hardmap);
    canvass=new_map(mapsizex,mapsizey,mapsizex/2,mapsizey/2,0);
    hardmap=new_map(mapsizex/2,mapsizey/2,mapsizex/4,mapsizey/4,0);
    define_region(1, 0, 0, 800, 600);
    start_scroll(0,0,canvass,0,1,0);
    clear_screen();
    for(n=0;n<maxsprites;n++)
        level.tiles[n].xpos=0;
        level.tiles[n].ypos=0;
        level.tiles[n].gfx=0;
        level.tiles[n].ang=0;
        level.tiles[n].group=0;
        level.tiles[n].mode=0;
        level.tiles[n].value=0;
        level.tiles[n].animframes=0;
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
    stop_scroll(0);
    unload_map(canvass);
    unload_map(hardmap);
    load("level"+itoa (mylevel)+".dat",offset level);
    level.screenswidth=screenswide;
    level.screensheight=screensdeep;
    mapsizex=64*12*screenswide;
    mapsizey=64*10*screensdeep;
    canvass=new_map(mapsizex,mapsizey,mapsizex/2,mapsizey/2,0);
    hardmap=new_map(mapsizex/2,mapsizey/2,mapsizex/4,mapsizey/4,0);
    define_region(1, 0, 0, 800, 600);
    start_scroll(0,0,canvass,0,1,0);
    //draw the saved(mylevel leve; ********
    for(n=0;n<maxsprites;n++)
        if(level.tiles[n].xpos>0)
            switch (level.tiles[n].mode)
                case 0;
                    mapput(level.tiles[n].xpos,level.tiles[n].ypos,level.tiles[n].gfx);
                    mypointer++;
                end
                case 1;
                    make_sprite(level.tiles[n].gfx,level.tiles[n].xpos,level.tiles[n].ypos,4);
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
//
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
//
Process make_button(graph,buttonval,x,y,size)
private
    Begin
        Loop
            frame();
        end
end