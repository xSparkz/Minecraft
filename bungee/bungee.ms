# register_channel('BungeeCord'); # Tell commandhelper to listen for communication on the BungeeCord channel

proc(_writeUTF, @ba, @str,

	@len = length(@str)
	
	if (@len > 200) {
		die('String too long')
	}
	
	ba_put_byte(@ba, 0)
	ba_put_byte(@ba, @len)
	ba_put_bytes(@ba, string_get_bytes(@str, 'ascii'))
)

proc(_writeShort, @ba, @int,

	ba_put_short(@ba, @int)

)

proc(_writeLength, @ba, @str,

	@length = length(@str)
	
	_writeShort(@ba, @length)

)

proc(_forward, @server, @message,

	@ba = byte_array()
	
	_writeUTF(@ba, 'Forward') # Tell bungee to forward the message
	_writeUTF(@ba, @server) # The server we are sending the message to, can be ALL or ONLINE, or custom
	_writeUTF(@ba, 'CommandhelperBungee') # Our channel name for communication cross-server
	_writeLength(@ba, @message) # Write the length of our message into our byte array as a short
	_writeUTF(@ba, @message) # Write our message to be sent
	
	send_plugin_message('BungeeCord', @ba); # Send the message	

)

 
proc(_changeserver, @player, @server,

       @ba = byte_array()
	   
       _writeUTF(@ba, 'Connect')
       _writeUTF(@ba, @server)      
	   
       send_plugin_message(@player, 'BungeeCord', @ba)
)


register_command(changeserver, 

    array(
    
        description: 'Sends a player to a different Server',
        
        usage: '/changeserver <server>',
    
        executor: closure(@alias, @sender, @args) {
        
			if (array_size(@args) != 1) {
			
				msg(''.color(RED).color(BOLD).'Improper Usage!');
				msg(''.color(RED).'Usage: /changeserver <server>');
				die(); # No need to go further					
			
			}
			
			_changeserver(player(), @args[0]);
                
        }
    )
)

register_command(sendtoserver, 

    array(
        description: 'Sends player to a different server',
        usage: '/sendtoserver <player> <server>',
        permission: 'ch.alias.bungee.sendtoserver',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        tabcompleter: closure(@alias, @sender, @args) {
            try{
                if(array_size(@args) == 0) {
                    return(all_players());
                }
                @search = @args[array_size(@args) - 1];
                    return(array_filter(all_players(), closure(@index, @player) {
                    return(equals_ic(@search, substr(@player, 0, length(@search))));
                }));
            } catch (RangeException @ErrorInfo) {
                # Ignore
            }
        },
    
        executor: closure(@alias, @sender, @args) {
        
			if (array_size(@args) < 2) {
			
				msg(''.color(RED).color(BOLD).'Improper Usage!');
				msg(''.color(RED).'Usage: /sendtoserver <player> <server>');
				die(); # No need to go further					
			
			}
			
			try {
				@plr = player(@args[0])
				@svr = @args[1]
				
				set_ploc(@plr, array(x:'0', y:'70', z:'-1'))
				_changeserver(@plr, @svr);
				
			} catch (PlayerOfflineException @ErrorInfo) {				
				msg('Player is Offline')
				die()
			}				
                
                
        
        }
    )
)

