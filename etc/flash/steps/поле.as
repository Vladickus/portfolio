//Колличесво ходов
var step_txt = 0;
//позиция игрока

var str_x:String = "abcdefgh";
var str_y:String = "87654321";
var str_party:String = "";

var step_XX:String = "";

var sel_x; // выбрано для хода
var sel_y;

// выбранный sprite
var sel_spr:String = "xxx";  // полный путь: _level0.stage_mc.roma_3  
var sel:String     = "";     // краткий путь: roma_3

var poz_x;
var poz_y;

var DDD_x = 70; // сдвиг игровой доски от верх/левого угла 'swf'
var DDD_y = 70;

//*Двумерные массивы с картой уровня*
var mtx_x = 8;     // ширина доски
var mtx_y = 8;     // высота доски
var spr_size = 50;  // размер 'знакоместа'


//общий
var stage_arr = new Array(mtx_x);

for (i=0; i<mtx_x; i++) 
{
	stage_arr[i] = new Array(mtx_y);
}

var field_num = 0;
var  luna_num = 0;
var  roma_num = 0;

draw_desk();

mouseListener = new Object();
Mouse.addListener(mouseListener);

mouseListener.onMouseDown = function()
{
	if( sel_spr == "xxx" )
	{
		trace("не выбрано!");
		// указали сразу на пустую клетку
	}
	else 
	{
		// указали на пустую клетку, но прежде
		// указали на костяшку "sel"
		trace("двигаем "+sel);
		
		nm_x = get_x_desk_coord(); // куда
		nm_y = get_y_desk_coord();

		om_x = Math.round( (_root["sel_spr"]._x+_root.spr_size/2)/_root.spr_size +0.5)-1;
		om_y = Math.round( (_root["sel_spr"]._y+_root.spr_size/2)/_root.spr_size +0.5)-1;

		if( stage_arr[nm_x][nm_y] == "R" or stage_arr[nm_x][nm_y] == "L" or
			stage_arr[nm_x][nm_y] == "r" or stage_arr[nm_x][nm_y] == "l" or
			nm_x == om_x or nm_y == om_y )
		{
			trace("занято!");
			sel_spr = "xxx";
			// можно ходить только на пустые клетки
			// если указано на другую костяшку, то
			// выбранной считается теперь [она]
		}
		else
		{
//			trace("x>"+ _root["sel_spr"]._x);
//			trace("y>"+ _root["sel_spr"]._y);
	
//			om_x = Math.round( (_root["sel_spr"]._x+_root.spr_size/2)/_root.spr_size +0.5)-1;
//			om_y = Math.round( (_root["sel_spr"]._y+_root.spr_size/2)/_root.spr_size +0.5)-1;
			
		
//			if( isVictor( om_x, om_y) == true )
//			{
//				// должен бить
//				trace("из "+ get_chr_coord(om_x, om_y) +" должен бить");
//			}

			// если шажок не противоречит правилам - шагнуть
			draw_step( om_x, om_y, nm_x, nm_y);
		}
	}
}

function print_desk()
{
	for (i=0; i<mtx_y; i++) 
	{
		var line = "";
		for (j=0; j<mtx_x; j++) 
		{	
			switch( stage_arr[j][i] )
			{
				case "W": line += "+"; break;
				case "B": line += "."; break;
				
				case "R": line += "@"; break;
				case "L": line += "%"; break;
				
				case "r": line += "#"; break;
				case "l": line += "0"; break;
				
				default: line += " ";
			}
		}
		
		trace( (8-i)+" "+line);
	}
}

function get_x_desk_coord()
{
	m_x = Math.round( (_root._xmouse-_root.DDD_x+_root.spr_size/2)/_root.spr_size +0.5)-1;
 	if(m_x<0) { m_x = -1;  }
	
	return m_x;
}

function get_y_desk_coord()
{
	m_y = Math.round( (_root._ymouse-_root.DDD_y+_root.spr_size/2)/_root.spr_size +0.5)-1;
 	if(m_y<0) { m_y = -1;  }
	
	return m_y;
}

function get_chr_coord( px, py)
{
	return str_x.charAt(px) +str_y.charAt(py);
}

// заполнить 'мнимую доску'
// и отрисовать её
function draw_desk() 
{
	luna_num = 0;
	roma_num = 0;
	
	str_party = "";
	_root.party = str_party;
	
	var ch_x = -1;
	var ch_y = 1;
	
	for (i=0; i<mtx_x; i++) 
	{
		ch_x *= -1
		
		for (j=0; j<mtx_y; j++) 
		{	
			ch_y *= -1;
			
			if( ch_x * ch_y < 0 ) 
			{
				stage_arr[i][j] = "W"; // светлые клетки
			}
			else // кости: первоначальная расстановка
			{
				stage_arr[i][j] = "B"; // тёмные клетки
				
				if( j<3 )
				{
					stage_arr[i][j] = "L";
				}
				
				if( j>(mtx_y-4) )
				{
					stage_arr[i][j] = "R";
				}
			}// if/else
		}
	}

	draw_stage(); // отрисовать расположение костяшек
}

function draw_step( ox, oy, nx, ny) 
{
	trace("двигаем: "+ get_chr_coord(ox,oy)+"-"+get_chr_coord(nx,ny));
//	trace("luna num:"+ luna_num);
//	trace("roma num:"+ roma_num);

	// пометить в буфере "перемещение" костяшки
	stage_arr[nx][ny] = stage_arr[ox][oy];
	var c = stage_arr[ox][oy];
	stage_arr[ox][oy] = "B";
	trace("двигаем: ["+ c +"]");
	
	var nc = stage_arr[nx][ny];
	//if( nc == "r" ) nc = "R";
	//if( nc == "l" ) nc = "L";
	
	// решить какой клип перемещения выбрать
	if( nx>ox and ny<oy )  
	{
		if( nx-ox == 2 and stage_arr[nx-1][ny+1]<>"B" )
		{
			draw_strike_NE(nx,ny, nc); // СВ
			
			if( stage_arr[nx-1][ny+1]<>"B" )
			{
				//trace("kill");
				draw_kill( nx-1, ny+1);
			}
		}
		else
		draw_step_NE(nx,ny, nc); // СВ
	}
	if( nx<ox and ny<oy )
	{
		if( nx-ox == -2 and stage_arr[nx+1][ny+1]<>"B" )
		{
			draw_strike_NW(nx,ny, nc); // СЗ
			
			if( stage_arr[nx+1][ny+1]<>"B" )
			{
				//trace("kill");
				draw_kill( nx+1, ny+1);
			}
		}
		else
		draw_step_NW(nx,ny, nc); // СЗ
	}
	if( nx>ox and ny>oy )
	{
		if( nx-ox == 2 and stage_arr[nx-1][ny-1]<>"B" )
		{
			draw_strike_SE(nx,ny, nc); // ЮВ
					
			if( stage_arr[nx-1][ny-1]<>"B" )
			{
				//trace("kill_SE");
				draw_kill( nx-1, ny-1);
			}
		}
		else
		draw_step_SE(nx,ny, nc); // ЮВ
	}
	if( nx<ox and ny>oy )  
	{
		if( nx-ox == -2 and stage_arr[nx+1][ny-1]<>"B" )
		{
			draw_strike_SW(nx,ny, nc); // ЮЗ
			draw_kill( nx+1, ny-1);
		}
		else
		{
			draw_step_SW( nx,ny, nc); // ЮЗ
		}
	}

	// новое место
	pos_x = nx;
	pos_y = ny;
	this["sel_spr"]._visible = false;

	// строка ходов	
	str_party += stage_arr[nx][ny]+get_chr_coord(ox,oy)+"-"+get_chr_coord(nx,ny)+" ";
	_root.party = str_party;
}

function del( xx, yy)
{
	nx = xx*spr_size;
	ny = yy*spr_size;
	c = stage_arr[xx][yy];

	if( c == "L" or c == "l")
	{
		for(i=0; i<luna_num; i++) 
		{
			// удалить спрайт с доски
			if( stage_mc["luna_"+i]._x == nx and stage_mc["luna_"+i]._y == ny )
			{
				trace("del luna: "+i);
				stage_mc["luna_"+i].removeMovieClip();
				stage_arr[xx][yy] = "B";
			}
		}
	}
	else
	{//   c == "R" or c == "r"
		
		for(i=0; i<roma_num; i++) 
		{
			if( stage_mc["roma_"+i]._x == nx and stage_mc["roma_"+i]._y == ny )
			{
				trace("del roma: "+i);
				stage_mc["roma_"+i].removeMovieClip();
				stage_arr[xx][yy] = "B";
			}
		}
	}
	
	isComplete();
}

function draw_kill( xx, yy)
{
	// съедено
	if( sel_spr == "xxx" )
	{
	}
	else
	{
		c = stage_arr[xx][yy];
		if( c == "l" ) c = "L";
		if( c == "r" ) c = "R";
		
		stage_mc.attachMovie(c+"_kill", "kill", 3000, {_x:spr_size*xx, _y:spr_size*yy});	
		// создать 'исчезающего'
		
		del( xx, yy);
	}
}

function draw_end()
{
	// нарисовать последнее положение
	//trace(sel_spr+" end: ("+pos_x+","+pos_y+")");
	trace("end["+sel+"]: ("+pos_x+","+pos_y+")");
	
	this["sel_spr"]._x = pos_x*spr_size;//+ DDD_x;
	this["sel_spr"]._y = pos_y*spr_size;//+ DDD_y;
	
	// может стала дамкой?
	if( pos_y == 0 and sel.charAt(0) == "r" )
	{
		trace("roma дамка: "+ sel);
		make_dom(sel);
	}
	if( pos_y == 7 and sel.charAt(0) == "l" )
	{
		trace("luna дамка: "+ sel);
		make_dom(sel);
	}

	this["sel_spr"]._visible = true;
	sel_spr = "xxx";
	sel     = "xxx";
	// удалить 'клип перехода'
	stage_mc["step_XX"].removeMovieClip();
	step_XX = "";
}

// 'перевернуть дамку'
function make_dom(sh)
{
	// sh = "roma_5", например
	
	var c = sh.charAt(0);
	var num = sh.substr(5,3);
	num++; num--;
	var xx = pos_x*spr_size;
	var yy = pos_y*spr_size;
	
	trace( num+" удаляем: "+ sh +" <- "+ c+"_dom");
	stage_mc[sh].removeMovieClip();
	
	if( c == "R" or c == "r" )
	stage_mc.attachMovie("r_dom", sh, 7000+num, {_x:xx, _y:yy});		
	else
	stage_mc.attachMovie("l_dom", sh, 8000+num, {_x:xx, _y:yy});		
	
	stage_arr[pos_x][pos_y] = c; //  R->r(дамка) L->l(дамка)
}

function draw_strike_NE(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_strike_NE", "step_NE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_strike_NE", "step_NE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	

	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_NE";
}
function draw_step_NE(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_step_NE", "step_NE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_step_NE", "step_NE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_NE";
}
function draw_strike_NW(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_strike_NW", "step_NW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_strike_NW", "step_NW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_NW";
}
function draw_step_NW(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_step_NW", "step_NW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_step_NW", "step_NW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_NW";
}
function draw_strike_SW(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_strike_SW", "step_SW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_strike_SW", "step_SW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});		
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_SW";
}
function draw_step_SW(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_step_SW", "step_SW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_step_SW", "step_SW", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_SW";
}
function draw_strike_SE(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_strike_SE", "step_SE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_strike_SE", "step_SE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	
	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_SE";
}
function draw_step_SE(i,j, c)
{
	if( c == "R" or c == "L")
	stage_mc.attachMovie(c+"_step_SE", "step_SE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});	
	else
	stage_mc.attachMovie(c+"_dom_step_SE", "step_SE", 3000+luna_num, {_x:spr_size*i, _y:spr_size*j});		

	// запомнить название, чтобы потом (в draw_step) стереть
	step_XX = "step_SE";
}

function draw_stage() 
{
	//создаем клип, в котором будем все рисовать
	_root.createEmptyMovieClip("desk", 1);
	_root.createEmptyMovieClip("stage_mc", 2);
	
	stage_mc._x = DDD_x;
	stage_mc._y = DDD_y;
	
	desk._x = DDD_x;
	desk._y = DDD_y;

	// отобразить противостояние
	for (i=0; i<mtx_x; i++) 
	{
		for (j=0; j<mtx_y; j++) 
		{	
			if( stage_arr[i][j] == "W" ) // светлые клетки
			{
				desk.attachMovie("wfield", "wfield_"+ i+"_"+j, 1000+field_num, {_x:spr_size*i, _y:spr_size*j});
				field_num++;
			}
			else // кости
			{
				if( stage_arr[i][j] == "L" )
				{
					stage_mc.attachMovie("luna", "luna_"+ luna_num, 2050+luna_num, {_x:spr_size*i, _y:spr_size*j});
					luna_num++;
				}
				if( stage_arr[i][j] == "l" )
				{
					stage_mc.attachMovie("l_dom", "luna_"+ luna_num, 2050+luna_num, {_x:spr_size*i, _y:spr_size*j});
					luna_num++;
				}
				
				if( stage_arr[i][j] == "R" )
				{
					stage_mc.attachMovie("roma", "roma_"+ roma_num, 2000+roma_num, {_x:spr_size*i, _y:spr_size*j});
					roma_num++;
				}
				if( stage_arr[i][j] == "r" )
				{
					stage_mc.attachMovie("r_dom", "roma_"+ roma_num, 2000+roma_num, {_x:spr_size*i, _y:spr_size*j});
					roma_num++;
				}
			}// if / else
		}
	}
	
	isComplete();	
}

function isComplete()
{
	var luna_live = 0;
	var roma_live = 0;
	
	// проверка не окончена ли партия
	for (i=0; i<mtx_x; i++) 
	{
		for (j=0; j<mtx_y; j++) 
		{	
			if( stage_arr[i][j] == "l" or stage_arr[i][j] == "L")  luna_live++;
			if( stage_arr[i][j] == "r" or stage_arr[i][j] == "R")  roma_live++;
		}
	}
	
	if( roma_live == 0 or luna_live == 0 )
	{
		trace("=========[ игра окончена ]=========");
		_root.message.gotoAndStop(3);
		return true;
	}
/*	
	//trace( roma_live+" === "+luna_live);
	for (i=0; i<mtx_x; i++) 
	{
		for (j=0; j<mtx_y; j++) 
		{	
			if( isStepped(i,j) == true )
			{
				//trace("===[ некуда ходить ]===");
				//_root.mm.mmm.txt = "===";
								
				// поскольку хоть один 'шажок' возможен
				return false;   // игра не окончена
			}
		}
	}
	
	trace("===[ некуда ходить ]===");
	_root.message.gotoAndStop(4);
	return true; // игра окончена
*/
}

function goodStep( om_x, om_y, nm_x, nm_y)
{
	// вернёт 'true' если ход правильный
	
	return true;	
}

function isVictor( xx, yy)
{
	// вернёт 'true' если шашка должна 'бить'	
	
	if( stage_arr[xx][yy] == "R" )
	{
		if(
		   ( stage_arr[xx+1][yy+1]=="L" and stage_arr[xx+2][yy+2]=="B" ) or // SE
		   ( stage_arr[xx-1][yy-1]=="L" and stage_arr[xx-2][yy-2]=="B" ) or // NW
		   ( stage_arr[xx-1][yy+1]=="L" and stage_arr[xx-2][yy+2]=="B" ) or // SW
		   ( stage_arr[xx+1][yy-1]=="L" and stage_arr[xx+2][yy-2]=="B" )    // NE
		  )
		{
			return true;
		}
		else
		{
			return false; // 'бить' не должен
		}
	}
	
	if( stage_arr[xx][yy] == "L" )
	{
		if(
		   ( stage_arr[xx+1][yy+1]=="R" and stage_arr[xx+2][yy+2]=="B" ) or // SE
		   ( stage_arr[xx-1][yy-1]=="R" and stage_arr[xx-2][yy-2]=="B" ) or // NW
		   ( stage_arr[xx-1][yy+1]=="R" and stage_arr[xx-2][yy+2]=="B" ) or // SW
		   ( stage_arr[xx+1][yy-1]=="R" and stage_arr[xx+2][yy-2]=="B" )    // NE
		  )
		{
			return true;
		}
		else
		{
			return false; // 'бить' не должен
		}		
	}

}

function isStepped( xx, yy)
{
	// вернёт 'true' если есть куда шагнуть
	
	if( stage_arr[xx][yy] == "R" )
	{
		if( stage_arr[xx+1][yy-1]=="B" or "B"==stage_arr[xx-1][yy-1] ) 
		{
			return true;
		}
		else
		{
			return false; // ходить некуда
		}
	}
	else // luna
	{
		if( stage_arr[xx+1][yy+1]=="B" or "B"==stage_arr[xx-1][yy+1] )
		{
			return true;
		}
		else
		{
			return false; // ходить некуда
		}		
	}
}