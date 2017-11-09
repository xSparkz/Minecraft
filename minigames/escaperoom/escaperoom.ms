proc(_setBlocks, @blocks, @world,

	foreach(@block in @blocks) {
		
		@blockid = @block[0]; # Block id
		@location = array(x:@block[1], y:@block[2], z:@block[3], world:@world)
		
		tmsg(player(), @blockid)

		set_block_at(@location, @blockid); # Place the block
		
	}

)

register_command(resetroom1, 

    array(
        description: 'Arrests a player and Jails them',
        usage: '/arrest <player> <reason>',
        permission: 'ch.alias.resetroom',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',        
    
        executor: closure(@alias, @sender, @args) {
		
			@blocks = array(
				array('1:1', '-67.0', '86.0', '49.0'),
				array('1:1', '-71.0', '87.0', '49.0')
				
			)
			
			_setBlocks(@blocks, 'escaperoom');
        
        }
    )
)

register_command(goto, 

    array(
        description: 'Teleports a player to a command block by name',
        usage: 'goto <location>',
        permission: 'ch.alias.goto',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',        
    
        executor: closure(@alias, @sender, @args) {
        
			if (array_size(@args) < 2) {
			
				msg(''.color(RED).color(BOLD).'Improper Usage!');
				msg(''.color(RED).'Usage: /goto <location>');
				die(); # No need to go further					
			
			}
			
			@allEntities = all_entities(pworld()); # Get an array of all entities in current world
			
			foreach(@entity in @allEntities){
			
				msg(entity_type(@entity));
			
			}
			
        }
    )
)