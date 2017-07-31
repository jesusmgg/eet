///generate_block(tile_x, tile_y, game_controller)
// Tries to generate a block with center in the given tile.
// Returns false is block can not be generated or true is it can and was generated.

var tile_x = argument0;
var tile_y = argument1;
var game_controller = argument2;

var block_w = irandom_range(2, 6);
var block_h = irandom_range(2, 6);

var direction_x = -1;
var direction_y = -1;

var possible = false;

//Check starting tile:
if (tile_x < 0 || tile_y < 0
    || tile_x >= game_controller.MAP_W 
    || tile_y >= game_controller.MAP_H)
{
    return false;
}

var tile_status = ds_grid_get(game_controller.grid_occupation, tile_x, tile_y);
if (tile_status != game_controller.TILE_FREE) {return false;}

//Get direction:
for (direction_x=-1; direction_x<=1; direction_x++)
{
    for (direction_y=-1; direction_y<=1; direction_y++)
    {
        if (direction_x == 0 || direction_y == 0) {continue;}    
    
        var try_x = tile_x + direction_x;
        var try_y = tile_y + direction_y;
        
        if (try_x < 0 || try_y < 0 
            || try_x >= game_controller.MAP_W 
            || try_y >= game_controller.MAP_H)
        {
            possible = false;
            continue;
        }
        
        var tile_status = ds_grid_get(game_controller.grid_occupation, try_x, try_y);
        if (tile_status == game_controller.TILE_FREE)
        {
            possible = true;
            break;
        }
        else {possible = false;}        
    }
    if (possible == true) {break;}
}

if (possible == false) {return false;}

var block_start_x = 0;
var block_start_y = 0;
var block_end_x = 0;
var block_end_y = 0;

if (direction_x == -1)
{
    block_start_x = tile_x - (block_w - 1);
    block_end_x = tile_x;
}
else if (direction_x == 1)
{
    block_start_x = tile_x;
    block_end_x = tile_x + (block_w - 1);
}

if (direction_y == -1)
{
    block_start_y = tile_y - (block_h - 1);
    block_end_y = tile_y;
}
else if (direction_y == 1)
{
    block_start_y = tile_y;
    block_end_y = tile_y + (block_h - 1);
}

//Check all block tiles for occupation, reservation or out of bounds:
for (var i=block_start_x; i<=block_end_x; i++)
{
    for (var j=block_start_y; j<=block_end_y; j++)
    {
        if (i < 0 || j < 0
            || i >= game_controller.MAP_W 
            || j >= game_controller.MAP_H)
        {
            possible = false;
            break;
        }
    
        var tile_status = ds_grid_get(game_controller.grid_occupation, i, j);
        if (tile_status == game_controller.TILE_FREE) {continue;}
        else
        {
            possible = false;
            break;
        }
    }
    if (possible == false) {break;}
}

if (possible == false) {return false;}

//If generation is possible, generate center building:
var house = instance_create(tile_x*32, tile_y*32, obj_house_small);
house.is_block_center = true;
house.block_w = block_w;
house.block_h = block_h;

house.block_start_x = block_start_x;
house.block_start_y = block_start_y;
house.block_end_x = block_end_x;
house.block_end_y = block_end_y;

house.tile_x = tile_x;
house.tile_y = tile_y;

house.block_center = house;
house.game_controller = game_controller;

//Reserve block tiles:
for (var i=block_start_x; i<=block_end_x; i++)
{
    for (var j=block_start_y; j<=block_end_y; j++)
    {
        ds_grid_set(
            game_controller.grid_occupation,
            i, j,
            game_controller.TILE_RESERVED
        );
    }
}

//Occupy current tile:
ds_grid_set(
    game_controller.grid_occupation,
    tile_x, tile_y,
    game_controller.TILE_OCCUPIED
);

//Generate asphalt:
for (var i=block_start_x-1; i<=block_end_x+1; i++)
{
    for (var j=block_start_y-1; j<=block_end_y+1; j++)
    {
        if (i < 0 || j < 0
            || i >= game_controller.MAP_W 
            || j >= game_controller.MAP_H)
        {
            continue;
        }
        
        var tile_status = ds_grid_get(game_controller.grid_occupation, i, j);
        if (tile_status == game_controller.TILE_FREE)
        {
            instance_create(i*32, j*32, obj_asphalt);
            ds_grid_set(
                game_controller.grid_occupation,
                i, j,
                game_controller.TILE_OCCUPIED
            );
        }
    }
}

return true;
