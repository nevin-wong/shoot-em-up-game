#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto
#
# Student: Name, Student Number, UTorID
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 
# - Unit height in pixels: 8 
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# - Milestones 1, 2, 3, 4
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. There is an increase in difficulty as the game progresses. Throughout the game,
#    there is a wormhole that the ship cannot travel below. Also, no obstacle will
#    spawn below the wormhole. As the game progresses, the wormhole will rise, causing the
#    player to have less space to avoid the obstacles. (The times the wormhole rises is
#    randomized, but it happens roughly every 7 seconds)
# 2. There is a scoring system that displays the number of obstacles avoided/destroyed.
#    The objective of the game is to get the highest score.
# 3. The ship can deploy a bullet to destroy obstacles in its path if they want. However,
#    they must keep in mind there can only be one bullet on screen at a time, so they must 
#    use their bullet wisely, and only when they need to.
# Extra: there is also diagonal movement, using the keys q, e, z, c.
#
# Link to video demonstration for final submission:
# - https://www.youtube.com/watch?v=UVAh3txU1sg
#
# Are you OK with us sharing the video with people outside course staff?
# - Yes!
#
# Any additional information that the TA needs to know:
#   Thanks for being such a great TA this semester!
#
#####################################################################

.eqv BASE_ADDRESS 0x10008000
.eqv BUFFER 29
.eqv LOWER_BOUND 53
.eqv WORMHOLE_COLOUR 0xff00ff # purple
.eqv WHITE 0xffffff
.eqv BLACK 0x000000

.data
# textures3
ship_texture:		.word	0xc5cae9, 0x1a237e, 0x858ec4, 0x858ec4, # specific shape for the ship, each row has 4 pixels
					  0xc5cae9, 0x1a237e, 0x858ec4, 0x9c27b0, # indents indicate the shape of the ship
				                    0x858ec4, 0x858ec4, 0x858ec4, 0x9c27b0,
				          0xc5cae9, 0x1a237e, 0x858ec4, 0x9c27b0,
				0xc5cae9, 0x1a237e, 0x858ec4, 0x858ec4
damaged_ship_texture:	.word	WHITE, WHITE, WHITE, WHITE, # specific shape for the ship, each row has 4 pixels
					  WHITE, WHITE, WHITE, WHITE, # indents indicate the shape of the ship
				                    WHITE, WHITE, WHITE, WHITE,
				          WHITE, WHITE, WHITE, WHITE,
				WHITE, WHITE, WHITE, WHITE
small_obs_texture_1:	.word	0x757575, 0x9e9e9e, 0x757575, # 3x3
				0x9e9e9e, 0x757575, 0x9e9e9e,
				0xbdbdbd, 0x9e9e9e, 0x757575
small_obs_texture_2:	.word	0xf57b00, 0xffc400, 0xf57b00,
				0xffc400, 0xffeb3b, 0xffc400,
				0xf57b00, 0xffc400, 0xf57b00
med_obs_texture_1:	.word	BLACK, 0x4fc2f7, 0x81d4fa, BLACK, # 4x4
				0x4fc2f7, 0x03a8f4, 0x4fc2f7, 0x81d4fa,
				0x81d4fa, 0x4fc2f7, 0x0288d1, 0x4fc2f7,
				BLACK, 0x81d4fa, 0x4fc2f7, BLACK
med_obs_texture_2:	.word	BLACK, 0xbdbdbd, 0x9e9e9e, 0xbdbdbd,
				0xbdbdbd, 0x757575, 0x757575, 0x9e9e9e,
				0x9e9e9e, 0x696969, 0x757575, 0xbdbdbd,
				0xbdbdbd, 0x9e9e9e, 0xbdbdbd, BLACK
big_obs_texture_1:	.word	BLACK, 0x696969, 0x9e9e9e, BLACK, BLACK, # 5x5
				0x9e9e9e, 0x696969, 0x696969, 0x696969, 0x9e9e9e,
				BLACK, 0x9e9e9e, 0x696969, 0x696969, 0x696969,
				0x696969, BLACK, 0x9e9e9e, 0x696969, 0x9e9e9e,
				0x9e9e9e, BLACK, BLACK, 0x9e9e9e, BLACK
big_obs_texture_2:	.word	BLACK, 0x303f9f, BLACK, BLACK, 0x757575,
				0x303f9f, 0xbdbdbd, 0x303f9f, 0x757575, BLACK,
				BLACK, 0x303f9f, 0xbdbdbd, 0x303f9f, BLACK,
				BLACK, 0x757575, 0x303f9f, 0xbdbdbd, 0x303f9f,
				0x757575, BLACK, BLACK, 0x303f9f, BLACK
life_texture:		.word	BLACK, 0xe53835, BLACK, 0xe53835, BLACK, # 4x5
				0xe53835, 0xd12522, 0xe53835, 0xd12522, 0xe53835,
				BLACK, 0xe53835, 0xd12522, 0xe53835, BLACK,
				BLACK, BLACK, 0xe53835, BLACK, BLACK
game_over_texture:	.word	WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, #7x7
				WHITE, WHITE, 0x9c27b0, WHITE, 0x9c27b0, WHITE, WHITE,
				WHITE, WHITE, 0x9c27b0, WHITE, 0x9c27b0, WHITE, WHITE,
				WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE,
				WHITE, WHITE, 0x9c27b0, 0x9c27b0, 0x9c27b0, WHITE, WHITE,
				WHITE, 0x9c27b0, WHITE, WHITE, WHITE, 0x9c27b0, WHITE,
				WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE
number_textures:	.word	# 0
				BLACK, BLACK, BLACK, BLACK, BLACK, # all 7x5
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 1
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, WHITE, WHITE, BLACK, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 2
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, WHITE, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 3
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 4
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 5
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 6
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 7
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 8
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK,
				# 9
				BLACK, BLACK, BLACK, BLACK, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, WHITE, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, WHITE, BLACK, 
				BLACK, BLACK, BLACK, WHITE, BLACK, 
				BLACK, WHITE, WHITE, BLACK, BLACK, 
				BLACK, BLACK, BLACK, BLACK, BLACK
# coordinates of the middle pixel of the ship (range: 0-63)
ship_x:		.word	32
ship_y:		.word	32

# arrays of entities:
# Entry 1: x coord (range: 0-63)
# Entry 2: y coord (range: 0-63)
# Entry 3: size (range: 0-2; 0 for small, 1 for medium, 2 for big)
# Entry 4: texture number (range: 0-1)
# Entry 5: velocity (range: 1-3)
# Entry 6: if this has been hit or not by the ship (range: 0-1)
obstacle_1:	.word	0:6
obstacle_2:	.word	0:6
obstacle_3:	.word	0:6
obstacle_4:	.word	0:6
obstacle_5:	.word	0:6
obstacle_6:	.word	0:6
obstacle_7:	.word	0:6

# array of the bullet
# Entry 1: x coord (range: 0-63)
# Entry 2: y coord (range: 0-63)
# Entry 3: status (range: 0-1; 0 for inactive, 1 for active)
bullet:		.word 0:3

.text

pre_game:
# GLOBAL VARIABLES STORED IN REGISTERS:
	# half and third trackers
	li $s0, 0		# initialize counters that indicate every other loop and every third loop
	li $s1, 0
	# lives
	li $s2, 10		# $s2 stores the number of lives of the ship
	# score
	li $s3, 0		# $s3 stores the score - the number of ships avoided
	# wormhole level
	li $s4, LOWER_BOUND

# establish the coordinates of the ship to be 32 (for game restarts)
	la $t0, ship_x
	li $t1, 32
	sw $t1, 0($t0)
	la $t0, ship_y
	sw $t1, 0($t0)

# establish the bullet to be inactive
	la $t0, bullet
	sw $zero, 8($t0)

# establish random values for the obstacles
	la $a0, obstacle_1
	jal randomize_obs
	la $a0, obstacle_2
	jal randomize_obs
	la $a0, obstacle_3
	jal randomize_obs
	la $a0, obstacle_4
	jal randomize_obs
	la $a0, obstacle_5
	jal randomize_obs
	la $a0, obstacle_6
	jal randomize_obs
	la $a0, obstacle_7
	jal randomize_obs
	
# draw the lives at the bottom
	la $a0, life_texture
	li $a1, 2
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 8
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 14
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 20
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 26
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 32
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 38
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 44
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 50
	li $a2, 59
	jal draw_4x5_texture
	li $a1, 56
	li $a2, 59
	jal draw_4x5_texture
	
# draw the wormhole at its initial state
	move $a0, $s4
	jal draw_wormhole

game_loop: # central processing loop of the game
	xori $s0, $s0, 1 # $s0 tracks if this is an even or odd loop, switches between 0 and 1 every loop
	
	addi $s1, $s1, 1 # $s1 switches between 0, then 1, then 2 every loop to indicate every third loop
	bne $s1, 3, fi_three 
if_three:
	li $s1, 0
fi_three:

# use a 1 in 210 chance randomizer to randomly increase the wormhole level by 1
# this is so that the wormhole increases roughly every 7 seconds
	
	li $v0, 42
	li $a0, 0
	li $a1, 210
	syscall
	bnez $a0, no_raise
	
raise_wormhole:
	move $a0, $s4
	jal erase_wormhole
	addi $s4, $s4, -1
no_raise:

# in the extremely unlikely event that the wormhole reaches y coordinate of 5 (making it very difficult to play,
# so I don't expect anyone to be able to) reset the wormhole.
	li $t0, 5
	bge $s4, $t0, leave_wormhole
	
	li $t0, LOWER_BOUND
	move $s4, $t0
leave_wormhole:

# check if the number of lives is zero, if it is, end the game
	beqz $s2, game_over_state

# erase old ship
	jal erase_ship

# erase old obstacles
	la $a0, obstacle_1
	jal erase_obs
	la $a0, obstacle_2
	jal erase_obs
	la $a0, obstacle_3
	jal erase_obs
	la $a0, obstacle_4
	jal erase_obs
	la $a0, obstacle_5
	jal erase_obs
	la $a0, obstacle_6
	jal erase_obs
	la $a0, obstacle_7
	jal erase_obs

# erase old bullet
	jal erase_bullet

# check for a keypress
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, deal_with_keypress
	j end_keypress

deal_with_keypress:
	lw $t2, 4($t9)
	# p to restart
	beq $t2, 0x70, respond_to_p
	# wasd to move
	beq $t2, 0x77, respond_to_w
	beq $t2, 0x61, respond_to_a
	beq $t2, 0x73, respond_to_s
	beq $t2, 0x64, respond_to_d
	beq $t2, 0x78, respond_to_s # can either use the tradidional s for down,
				     # or x, because of the diagonal button placements
	# diagonals
	beq $t2, 0x65, respond_to_e
	beq $t2, 0x71, respond_to_q
	beq $t2, 0x7A, respond_to_z
	beq $t2, 0x63, respond_to_c
	# shooting the bullet
	beq $t2, 0x20, respond_to_space
	j end_keypress

respond_to_p: 
	# no need to erase the lives since they'll be drawn over
	# erase the bullet
	jal erase_bullet
	# erase the wormhole
	move $a0, $s4
	jal erase_wormhole
	# erase the ship
	jal erase_ship
	# erase the obstacles as well
	la $a0, obstacle_1
	jal erase_obs
	la $a0, obstacle_2
	jal erase_obs
	la $a0, obstacle_3
	jal erase_obs
	la $a0, obstacle_4
	jal erase_obs
	la $a0, obstacle_5
	jal erase_obs
	la $a0, obstacle_6
	jal erase_obs
	la $a0, obstacle_7
	jal erase_obs
	j pre_game

respond_to_w: # update the y coord accordingly
	la $t0, ship_y
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_a: # update the x coord accordingly
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_s: # update the y coord accordingly
	la $t0, ship_y
	lw $t1, 0($t0)
	move $t4, $s4
	bge $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_d: # update the x coord accordingly
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 60
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_e: # update x and y coords accordingly
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 60
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	la $t0, ship_y
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress
	
respond_to_q: # update x and y coords accordingly
	la $t0, ship_y
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_z:
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 2
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, -1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	la $t0, ship_y
	lw $t1, 0($t0)
	move $t4, $s4
	bge $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_c:
	la $t0, ship_x
	lw $t1, 0($t0)
	li $t4, 60
	beq $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	la $t0, ship_y
	lw $t1, 0($t0)
	move $t4, $s4
	bge $t1, $t4, end_keypress	# prevent ship from going out of bounds
	li $t3, 1
	add $t1, $t1, $t3
	sw $t1, 0($t0)
	j end_keypress

respond_to_space: # spawn the bullet if it is inactive
	la $t0, bullet
	lw $t1, 8($t0)			# get the bullet's status
	beqz $t1, spawn_bullet		# if it is zero, spawn it in to the ship's location
	j end_spawn_bullet
	spawn_bullet:
		li $t2, 1
		sw $t2, 8($t0)
		la $t3, ship_y
		lw $t1, 0($t3)
		sw $t1, 4($t0)
		la $t3, ship_x
		lw $t1, 0($t3)
		li $t4, 2
		add $t1, $t1, $t4	# add 2 to the bullet's x coord
		sw $t1, 0($t0)
	end_spawn_bullet:

end_keypress:

# prevent the ship from going below the wormhole
	la $t0, ship_y
	lw $t1, 0($t0)
	ble $t1, $s4, end_prevention # prevent ship from going out of bounds
	sw $s4, 0($t0)
end_prevention:

# if the bullet is active, move it to the right and draw it
	la $t0, bullet
	lw $t1, 8($t0)			# get the bullet's status
	beqz $t1, end_update_bullet	# if it is zero, don't update it
	update_bullet:
		lw $t1, 0($t0)
		addi $t1, $t1, 2
		sw $t1, 0($t0)
		jal draw_bullet
	end_update_bullet:

# update obstacles' new locations
	la $a0, obstacle_1
	jal update_location
	la $a0, obstacle_2
	jal update_location
	la $a0, obstacle_3
	jal update_location
	la $a0, obstacle_4
	jal update_location
	la $a0, obstacle_5
	jal update_location
	la $a0, obstacle_6
	jal update_location
	la $a0, obstacle_7
	jal update_location
	
# check if obstacles are out of bounds, if they are, spawn new randomized ones at the right edge, 
# also update score
	la $a0, obstacle_1
	jal check_bound
	la $a0, obstacle_2
	jal check_bound
	la $a0, obstacle_3
	jal check_bound
	la $a0, obstacle_4
	jal check_bound
	la $a0, obstacle_5
	jal check_bound
	la $a0, obstacle_6
	jal check_bound
	la $a0, obstacle_7
	jal check_bound

# check if the bullet is out of bounds, if it is, deactivate it
	la $t0, bullet
	lw $t1, 0($t0)	# x coord of bullet
	li $t2, 62
	blt $t1, $t2, end_deactiv_bullet
deactiv_bullet:
	sw $zero, 8($t0)
end_deactiv_bullet:

# calculate new location offset (ship)
	la $t0, ship_x
	lw $t1, 0($t0)		# $t1 gets the x coordinate of the ship
	la $t0, ship_y
	lw $t2, 0($t0) 		# $t2 gets the y coordinate of the ship
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t7, $t4, $t0	# $t7 now stores the offset multiplied by 4 added to the base address

# check for bullet-obstacle collisions, if it happens it will destroy both the ship and the bullet

	la $t0, bullet
	lw $t1, 8($t0)
	beqz $t1, no_check	# if the bullet is not activated, do not bother to check
	
	la $a0, obstacle_1
	jal chk_bullet_collision
	la $a0, obstacle_2
	jal chk_bullet_collision
	la $a0, obstacle_3
	jal chk_bullet_collision
	la $a0, obstacle_4
	jal chk_bullet_collision
	la $a0, obstacle_5
	jal chk_bullet_collision
	la $a0, obstacle_6
	jal chk_bullet_collision
	la $a0, obstacle_7
	jal chk_bullet_collision
no_check:

# draw obstacles in new locations
	la $a0, obstacle_1
	jal draw_obs
	la $a0, obstacle_2
	jal draw_obs
	la $a0, obstacle_3
	jal draw_obs
	la $a0, obstacle_4
	jal draw_obs
	la $a0, obstacle_5
	jal draw_obs
	la $a0, obstacle_6
	jal draw_obs
	la $a0, obstacle_7
	jal draw_obs

# check for ship-obstacle collisions, boolean is returned in $v0
	li $t6, 0 # $t6 will indicate if any collision occured
	li $v1, 0 # $v1 will switch to 1 if the ship has lost a life

	la $a0, obstacle_1
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_2
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_3
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_4
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_5
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_6
	jal check_collision
	or $t6, $t6, $v0
	la $a0, obstacle_7
	jal check_collision
	or $t6, $t6, $v0
	
	beqz $v1, no_lose_life
lose_life:

	li $a1, 2
	li $t0, 6
	mult $s2, $t0
	mflo $t0
	add $a1, $a1, $t0
	li $a2, 59
	jal erase_4x5_texture

no_lose_life:
	bnez $t6, draw_damaged

# draw new ship in new location
	la $t0, ship_texture

	lw $t2, 0($t0)		# $t2 gets the ship_texture array
	sw $t2, -520($t7)
	lw $t2, 4($t0)		# next pixel
	sw $t2, -516($t7)
	lw $t2, 8($t0)		# next pixel
	sw $t2, -512($t7)
	lw $t2, 12($t0)		# next pixel
	sw $t2, -508($t7)

	lw $t2, 16($t0)		# next pixel
	sw $t2, -260($t7)
	lw $t2, 20($t0)		# next pixel
	sw $t2, -256($t7)
	lw $t2, 24($t0)		# next pixel
	sw $t2, -252($t7)
	lw $t2, 28($t0)		# next pixel
	sw $t2, -248($t7)

	lw $t2, 32($t0)		# next pixel
	sw $t2, 0($t7)
	lw $t2, 36($t0)		# next pixel
	sw $t2, 4($t7)
	lw $t2, 40($t0)		# next pixel
	sw $t2, 8($t7)
	lw $t2, 44($t0)		# next pixel
	sw $t2, 12($t7)
	
	lw $t2, 48($t0)		# next pixel
	sw $t2, 252($t7)
	lw $t2, 52($t0)		# next pixel
	sw $t2, 256($t7)
	lw $t2, 56($t0)		# next pixel
	sw $t2, 260($t7)
	lw $t2, 60($t0)		# next pixel
	sw $t2, 264($t7)
	
	lw $t2, 64($t0)		# next pixel
	sw $t2, 504($t7)
	lw $t2, 68($t0)		# next pixel
	sw $t2, 508($t7)
	lw $t2, 72($t0)		# next pixel
	sw $t2, 512($t7)
	lw $t2, 76($t0)		# next pixel
	sw $t2, 516($t7)
	
	j end_draw_damaged

draw_damaged:
	la $t0, damaged_ship_texture

	lw $t2, 0($t0)		# $t2 gets the ship_texture array
	sw $t2, -520($t7)
	lw $t2, 4($t0)		# next pixel
	sw $t2, -516($t7)
	lw $t2, 8($t0)		# next pixel
	sw $t2, -512($t7)
	lw $t2, 12($t0)		# next pixel
	sw $t2, -508($t7)

	lw $t2, 16($t0)		# next pixel
	sw $t2, -260($t7)
	lw $t2, 20($t0)		# next pixel
	sw $t2, -256($t7)
	lw $t2, 24($t0)		# next pixel
	sw $t2, -252($t7)
	lw $t2, 28($t0)		# next pixel
	sw $t2, -248($t7)

	lw $t2, 32($t0)		# next pixel
	sw $t2, 0($t7)
	lw $t2, 36($t0)		# next pixel
	sw $t2, 4($t7)
	lw $t2, 40($t0)		# next pixel
	sw $t2, 8($t7)
	lw $t2, 44($t0)		# next pixel
	sw $t2, 12($t7)
	
	lw $t2, 48($t0)		# next pixel
	sw $t2, 252($t7)
	lw $t2, 52($t0)		# next pixel
	sw $t2, 256($t7)
	lw $t2, 56($t0)		# next pixel
	sw $t2, 260($t7)
	lw $t2, 60($t0)		# next pixel
	sw $t2, 264($t7)
	
	lw $t2, 64($t0)		# next pixel
	sw $t2, 504($t7)
	lw $t2, 68($t0)		# next pixel
	sw $t2, 508($t7)
	lw $t2, 72($t0)		# next pixel
	sw $t2, 512($t7)
	lw $t2, 76($t0)		# next pixel
	sw $t2, 516($t7)

end_draw_damaged:

# update score
	li $t0, 1000 # first digit
	div $s3, $t0
	mflo $t1
	mfhi $t9
	
	move $a0, $t1
	li $a1, 0
	li $a2, 0
	jal draw_number
	
	li $t0, 100 # second digit
	div $t9, $t0
	mflo $t1
	mfhi $t9
	
	move $a0, $t1
	li $a1, 5
	li $a2, 0
	jal draw_number
	
	li $t0, 10 # third digit
	div $t9, $t0
	mflo $t1
	mfhi $t9
	
	move $a0, $t1
	li $a1, 10
	li $a2, 0
	jal draw_number
	
	li $t0, 1 # fourth digit
	div $t9, $t0
	mflo $t1
	mfhi $t9
	
	move $a0, $t1
	li $a1, 15
	li $a2, 0
	jal draw_number

# draw the wormhole
	move $a0, $s4
	jal draw_wormhole

# sleep, then jump back to beginning of loop
	li $v0, 32
	li $a0, BUFFER 		# Wait BUFFER milliseconds
	syscall

	j game_loop
end_loop:

game_over_state:
	la $a0, game_over_texture
	li $a1, 29
	li $a2, 29
	jal draw_7x7_texture
	
game_over_loop: # continuously check for keypress (in particular, p)
	# check for a keypress
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, deal_with_keypress_end
	j end_keypress_end

	deal_with_keypress_end:
	lw $t2, 4($t9)
	beq $t2, 0x70, respond_to_p_end
	j end_keypress_end

respond_to_p_end:
	# erase the bullet
	jal erase_bullet
	# erase the wormhole
	move $a0, $s4
	jal erase_wormhole
	# erase the end texture
	li $a1, 29
	li $a2, 29
	jal erase_7x7_texture
	# erase the ship
	jal erase_ship
	# erase the obstacles as well
	la $a0, obstacle_1
	jal erase_obs
	la $a0, obstacle_2
	jal erase_obs
	la $a0, obstacle_3
	jal erase_obs
	la $a0, obstacle_4
	jal erase_obs
	la $a0, obstacle_5
	jal erase_obs
	la $a0, obstacle_6
	jal erase_obs
	la $a0, obstacle_7
	jal erase_obs
	j pre_game
	
end_keypress_end:
	j game_over_loop
game_over_loop_end:

### FUNCTIONS ###

randomize_obs: # $a0 stores the address of the obstacle we are randomizing
	move $t0, $a0
	li $v0, 42
	
	li $a0, 0 # x coord
	li $a1, 64
	syscall
	sw $a0, 0($t0)
	
	li $a0, 0 # y coord
	move $a1, $s4
	syscall
	sw $a0, 4($t0)
	
	li $a0, 0 # size
	li $a1, 3
	syscall
	sw $a0, 8($t0)
	
	li $a0, 0 # texture
	li $a1, 2
	syscall
	sw $a0, 12($t0)
	
	li $a0, 0 # velocity
	li $a1, 3
	syscall
	addi $a0, $a0, 1
	sw $a0, 16($t0)
	
	sw $zero, 20($t0) # set hit state to 0
	
	jr $ra
	
draw_obs: # $a0 stores the address of the obstacle to be drawn
	lw $t1, 0($a0)		# $t1 gets the x coordinate
	lw $t2, 4($a0) 		# $t2 gets the y coordinate
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	lw $t3, 8($a0)		# $t3 stores the size
	lw $t5, 12($a0)		# $t5 stores the texture number
	li $t0, 1
	beq $t3, $t0, draw_med_one
	li $t0, 2
	beq $t3, $t0, draw_big_one
draw_small_one:
	bnez $t5, draw_small_one2 	# if the texture number is not zero, draw the second one
	la $t0, small_obs_texture_1
	lw $t2, 0($t0)			# $t2 gets the texture
	sw $t2, -260($t4)
	lw $t2, 4($t0)			# next pixel
	sw $t2, -256($t4)
	lw $t2, 8($t0)			# next pixel
	sw $t2, -252($t4)
	lw $t2, 12($t0)			# next pixel
	sw $t2, -4($t4)
	lw $t2, 16($t0)			# next pixel
	sw $t2, 0($t4)
	lw $t2, 20($t0)			# next pixel
	sw $t2, 4($t4)
	lw $t2, 24($t0)			# next pixel
	sw $t2, 252($t4)
	lw $t2, 28($t0)			# next pixel
	sw $t2, 256($t4)
	lw $t2, 32($t0)			# next pixel
	sw $t2, 260($t4)
	jr $ra
draw_small_one2:
	la $t0, small_obs_texture_2
	lw $t2, 0($t0)			# $t2 gets the texture
	sw $t2, -260($t4)
	lw $t2, 4($t0)			# next pixel
	sw $t2, -256($t4)
	lw $t2, 8($t0)			# next pixel
	sw $t2, -252($t4)
	lw $t2, 12($t0)			# next pixel
	sw $t2, -4($t4)
	lw $t2, 16($t0)			# next pixel
	sw $t2, 0($t4)
	lw $t2, 20($t0)			# next pixel
	sw $t2, 4($t4)
	lw $t2, 24($t0)			# next pixel
	sw $t2, 252($t4)
	lw $t2, 28($t0)			# next pixel
	sw $t2, 256($t4)
	lw $t2, 32($t0)			# next pixel
	sw $t2, 260($t4)
	jr $ra
draw_med_one:
	bnez $t5, draw_med_one2		# if the texture number is not zero, draw the second one
	la $t0, med_obs_texture_1
	
	lw $t2, 0($t0)			# $t2 gets the texture
	sw $t2, -260($t4)
	lw $t2, 4($t0)			# next pixel
	sw $t2, -256($t4)
	lw $t2, 8($t0)			# next pixel
	sw $t2, -252($t4)
	lw $t2, 12($t0)			# next pixel
	sw $t2, -248($t4)
	
	lw $t2, 16($t0)			# next pixel
	sw $t2, -4($t4)
	lw $t2, 20($t0)			# next pixel
	sw $t2, 0($t4)
	lw $t2, 24($t0)			# next pixel
	sw $t2, 4($t4)
	lw $t2, 28($t0)			# next pixel
	sw $t2, 8($t4)
	
	lw $t2, 32($t0)			# next pixel
	sw $t2, 252($t4)
	lw $t2, 36($t0)			# next pixel
	sw $t2, 256($t4)
	lw $t2, 40($t0)			# next pixel
	sw $t2, 260($t4)
	lw $t2, 44($t0)			# next pixel
	sw $t2, 264($t4)
	
	lw $t2, 48($t0)			# next pixel
	sw $t2, 508($t4)
	lw $t2, 52($t0)			# next pixel
	sw $t2, 512($t4)
	lw $t2, 56($t0)			# next pixel
	sw $t2, 516($t4)
	lw $t2, 60($t0)			# next pixel
	sw $t2, 520($t4)
	
	jr $ra
draw_med_one2:
	la $t0, med_obs_texture_2
	
	lw $t2, 0($t0)			# $t2 gets the texture
	sw $t2, -260($t4)
	lw $t2, 4($t0)			# next pixel
	sw $t2, -256($t4)
	lw $t2, 8($t0)			# next pixel
	sw $t2, -252($t4)
	lw $t2, 12($t0)			# next pixel
	sw $t2, -248($t4)
	
	lw $t2, 16($t0)			# next pixel
	sw $t2, -4($t4)
	lw $t2, 20($t0)			# next pixel
	sw $t2, 0($t4)
	lw $t2, 24($t0)			# next pixel
	sw $t2, 4($t4)
	lw $t2, 28($t0)			# next pixel
	sw $t2, 8($t4)
	
	lw $t2, 32($t0)			# next pixel
	sw $t2, 252($t4)
	lw $t2, 36($t0)			# next pixel
	sw $t2, 256($t4)
	lw $t2, 40($t0)			# next pixel
	sw $t2, 260($t4)
	lw $t2, 44($t0)			# next pixel
	sw $t2, 264($t4)
	
	lw $t2, 48($t0)			# next pixel
	sw $t2, 508($t4)
	lw $t2, 52($t0)			# next pixel
	sw $t2, 512($t4)
	lw $t2, 56($t0)			# next pixel
	sw $t2, 516($t4)
	lw $t2, 60($t0)			# next pixel
	sw $t2, 520($t4)
	
	jr $ra
draw_big_one:
	bnez $t5, draw_big_one2		# if the texture number is not zero, draw the second one
	
	la $t0, big_obs_texture_1

	lw $t2, 0($t0)		# $t2 gets the texture array
	sw $t2, -520($t4)
	lw $t2, 4($t0)		# next pixel
	sw $t2, -516($t4)
	lw $t2, 8($t0)		# next pixel
	sw $t2, -512($t4)
	lw $t2, 12($t0)		# next pixel
	sw $t2, -508($t4)
	lw $t2, 16($t0)		# next pixel
	sw $t2, -504($t4)

	lw $t2, 20($t0)		# next pixel
	sw $t2, -264($t4)
	lw $t2, 24($t0)		# next pixel
	sw $t2, -260($t4)
	lw $t2, 28($t0)		# next pixel
	sw $t2, -256($t4)
	lw $t2, 32($t0)		# next pixel
	sw $t2, -252($t4)
	lw $t2, 36($t0)		# next pixel
	sw $t2, -248($t4)

	lw $t2, 40($t0)		# next pixel
	sw $t2, -8($t4)
	lw $t2, 44($t0)		# next pixel
	sw $t2, -4($t4)
	lw $t2, 48($t0)		# next pixel
	sw $t2, 0($t4)
	lw $t2, 52($t0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 56($t0)		# next pixel
	sw $t2, 8($t4)
	
	lw $t2, 60($t0)		# next pixel
	sw $t2, 248($t4)
	lw $t2, 64($t0)		# next pixel
	sw $t2, 252($t4)
	lw $t2, 68($t0)		# next pixel
	sw $t2, 256($t4)
	lw $t2, 72($t0)		# next pixel
	sw $t2, 260($t4)
	lw $t2, 76($t0)		# next pixel
	sw $t2, 264($t4)
	
	lw $t2, 80($t0)		# next pixel
	sw $t2, 504($t4)
	lw $t2, 84($t0)		# next pixel
	sw $t2, 508($t4)
	lw $t2, 88($t0)		# next pixel
	sw $t2, 512($t4)
	lw $t2, 92($t0)		# next pixel
	sw $t2, 516($t4)
	lw $t2, 96($t0)		# next pixel
	sw $t2, 520($t4)
	
	jr $ra
draw_big_one2:
	la $t0, big_obs_texture_2

	lw $t2, 0($t0)		# $t2 gets the texture array
	sw $t2, -520($t4)
	lw $t2, 4($t0)		# next pixel
	sw $t2, -516($t4)
	lw $t2, 8($t0)		# next pixel
	sw $t2, -512($t4)
	lw $t2, 12($t0)		# next pixel
	sw $t2, -508($t4)
	lw $t2, 16($t0)		# next pixel
	sw $t2, -504($t4)

	lw $t2, 20($t0)		# next pixel
	sw $t2, -264($t4)
	lw $t2, 24($t0)		# next pixel
	sw $t2, -260($t4)
	lw $t2, 28($t0)		# next pixel
	sw $t2, -256($t4)
	lw $t2, 32($t0)		# next pixel
	sw $t2, -252($t4)
	lw $t2, 36($t0)		# next pixel
	sw $t2, -248($t4)

	lw $t2, 40($t0)		# next pixel
	sw $t2, -8($t4)
	lw $t2, 44($t0)		# next pixel
	sw $t2, -4($t4)
	lw $t2, 48($t0)		# next pixel
	sw $t2, 0($t4)
	lw $t2, 52($t0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 56($t0)		# next pixel
	sw $t2, 8($t4)
	
	lw $t2, 60($t0)		# next pixel
	sw $t2, 248($t4)
	lw $t2, 64($t0)		# next pixel
	sw $t2, 252($t4)
	lw $t2, 68($t0)		# next pixel
	sw $t2, 256($t4)
	lw $t2, 72($t0)		# next pixel
	sw $t2, 260($t4)
	lw $t2, 76($t0)		# next pixel
	sw $t2, 264($t4)
	
	lw $t2, 80($t0)		# next pixel
	sw $t2, 504($t4)
	lw $t2, 84($t0)		# next pixel
	sw $t2, 508($t4)
	lw $t2, 88($t0)		# next pixel
	sw $t2, 512($t4)
	lw $t2, 92($t0)		# next pixel
	sw $t2, 516($t4)
	lw $t2, 96($t0)		# next pixel
	sw $t2, 520($t4)

	jr $ra
	
erase_obs: # $a0 stores the address of the obstacle to be erased
	lw $t1, 0($a0)		# $t1 gets the x coordinate
	lw $t2, 4($a0) 		# $t2 gets the y coordinate
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	lw $t3, 8($a0)		# $t3 stores the size
	li $t0, 1
	beq $t3, $t0, erase_med_one
	li $t0, 2
	beq $t3, $t0, erase_big_one
erase_small_one:
	li $t1, BLACK
	sw $t1, -260($t4)
	sw $t1, -256($t4)
	sw $t1, -252($t4)
	sw $t1, -4($t4)
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 252($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	jr $ra
erase_med_one:
	li $t1, BLACK
	sw $t1, -260($t4)
	sw $t1, -256($t4)
	sw $t1, -252($t4)
	sw $t1, -248($t4)
	sw $t1, -4($t4)
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 252($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	sw $t1, 264($t4)
	sw $t1, 508($t4)
	sw $t1, 512($t4)
	sw $t1, 516($t4)
	sw $t1, 520($t4)
	jr $ra
erase_big_one:
	li $t1, BLACK
	sw $t1, -520($t4)
	sw $t1, -516($t4)
	sw $t1, -512($t4)
	sw $t1, -508($t4)
	sw $t1, -504($t4)
	sw $t1, -264($t4)
	sw $t1, -260($t4)
	sw $t1, -256($t4)
	sw $t1, -252($t4)
	sw $t1, -248($t4)
	sw $t1, -8($t4)
	sw $t1, -4($t4)
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 248($t4)
	sw $t1, 252($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	sw $t1, 264($t4)
	sw $t1, 504($t4)
	sw $t1, 508($t4)
	sw $t1, 512($t4)
	sw $t1, 516($t4)
	sw $t1, 520($t4)
	jr $ra

update_location: # $a0 stores the address of the obstacle to be updated
	lw $t1, 16($a0)			# $t1 stores the obstacles's velocity
	lw $t2, 0($a0)			# $t1 stores the obstacles's x coord
	li $t3, 1
	bne $t3, $t1, vel_two_or_three	# here, the higher the velocity, the slower the obstacle is
adjust_x_coord:				# adjust the x coord by 1
	subi $t2, $t2, 1		# new x coord
	sw $t2, 0($a0)			# store the new coord back
	jr $ra
vel_two_or_three:			# velocity 3 - third of velocity 1, adjusts the x coordinate whtn $s1 is 1
	li $t3, 2
	li $t4, 1
	beq $t3, $t1, vel_two
	beq $s1, $t4, adjust_x_coord
	jr $ra
vel_two:				# velocity 2 - half velocity 1, adjusts the x coordinate whtn $s0 is 1
	beq $s0, $t4, adjust_x_coord
	jr $ra

check_bound: # $a0 stores the address of the obstacle to be erased
	lw $t2, 0($a0)		# $t2 stores the x coord
	li $t1, 2
	bge $t2, $t1, end_check_bound
	
	move $t0, $a0		# spawn in a new randomized obstacle, but it needs to come from the right side (x = 61)
	li $v0, 42
	
	li $a0, 0 # y coord randomized
	move $a1, $s4
	syscall
	sw $a0, 4($t0)

	li $t5, 61 # x coord should be 61
	sw $t5, 0($t0)
	
	li $a0, 0 # size randomized
	li $a1, 3
	syscall
	sw $a0, 8($t0)
	
	li $a0, 0 # texture randomized
	li $a1, 2
	syscall
	sw $a0, 12($t0)
	
	li $a0, 0 # velocity randomized
	li $a1, 3
	syscall
	addi $a0, $a0, 1
	sw $a0, 16($t0)
	
	sw $zero, 20($t0) # set hit state to 0
	addi $s3, $s3, 1
end_check_bound:
	jr $ra
	
check_collision: # $a0 stores the address of the obstacle to be checked, after the call $v0 stores 1 if there is a collision
	lw $t1, 0($a0)		# $t1 stores the x coord of obstacle
	lw $t2, 4($a0)		# $t2 stores the y coord of obstacle
	lw $t3, 8($a0)		# $t3 stores the size of the obstacle
	
	la $t0, ship_x
	lw $t4, 0($t0)		# $t4 gets the ship's x coord
	la $t0, ship_y
	lw $t5, 0($t0)		# $t5 gets the ship's y coord
	
	# as these are the coordinates of the middle pixel of the ship/obstacle, 
	# need to ensure they are not far enough away to ensure no collision
	
	sub $t4, $t4, $t1	# $t4 now stores the difference between the x coords
	sub $t5, $t5, $t2	# $t5 now stores the difference between the y coords
	
	li $t0, 1
	beq $t3, $t0, check_collision_med
	li $t0, 2
	beq $t3, $t0, check_collision_big
check_collision_small:
	li $t0, 4
	bge $t4, $t0, no_collision
	bge $t5, $t0, no_collision
	li $t0, -4
	ble $t4, $t0, no_collision
	ble $t5, $t0, no_collision
	j collision
check_collision_med:
	li $t0, 5
	bge $t4, $t0, no_collision
	bge $t5, $t0, no_collision
	li $t0, -5
	ble $t4, $t0, no_collision
	ble $t5, $t0, no_collision
	j collision
check_collision_big:
	li $t0, 6
	bge $t4, $t0, no_collision
	bge $t5, $t0, no_collision
	li $t0, -6
	ble $t4, $t0, no_collision
	ble $t5, $t0, no_collision
	j collision
no_collision:
	li $v0, 0
	jr $ra
collision:
	lw $t0, 20($a0)		# $t0 gets the hit state
	li $v0, 1
	bnez $t0, been_hit
not_been_hit:
	sw $v0, 20($a0)		# update the hit state to 1
	sub $s2, $s2, $v0	# subtract one life
	li $v1, 1
been_hit:
	jr $ra

draw_4x5_texture: # $a0 stores the address of the texture, $a1 the x coord, $a2 the y coord
	li $t3, 64
	mult $t3, $a2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $a1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address

	lw $t2, 0($a0)		# $t2 gets the texture array
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	
	lw $t2, 20($a0)		# next pixel
	sw $t2, 256($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 260($t4)
	lw $t2, 28($a0)		# next pixel
	sw $t2, 264($t4)
	lw $t2, 32($a0)		# next pixel
	sw $t2, 268($t4)
	lw $t2, 36($a0)		# next pixel
	sw $t2, 272($t4)
	
	lw $t2, 40($a0)		# next pixel
	sw $t2, 512($t4)
	lw $t2, 44($a0)		# next pixel
	sw $t2, 516($t4)
	lw $t2, 48($a0)		# next pixel
	sw $t2, 520($t4)
	lw $t2, 52($a0)		# next pixel
	sw $t2, 524($t4)
	lw $t2, 56($a0)		# next pixel
	sw $t2, 528($t4)
	
	lw $t2, 60($a0)		# next pixel
	sw $t2, 768($t4)
	lw $t2, 64($a0)		# next pixel
	sw $t2, 772($t4)
	lw $t2, 68($a0)		# next pixel
	sw $t2, 776($t4)
	lw $t2, 72($a0)		# next pixel
	sw $t2, 780($t4)
	lw $t2, 76($a0)		# next pixel
	sw $t2, 784($t4)
	
	jr $ra
	
erase_4x5_texture: # $a1 the x coord, $a2 the y coord
	li $t3, 64
	mult $t3, $a2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $a1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	li $t2, BLACK

	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	
	sw $t2, 256($t4)
	sw $t2, 260($t4)
	sw $t2, 264($t4)
	sw $t2, 268($t4)
	sw $t2, 272($t4)
	
	sw $t2, 512($t4)
	sw $t2, 516($t4)
	sw $t2, 520($t4)
	sw $t2, 524($t4)
	sw $t2, 528($t4)
	
	sw $t2, 768($t4)
	sw $t2, 772($t4)
	sw $t2, 776($t4)
	sw $t2, 780($t4)
	sw $t2, 784($t4)
	
	jr $ra
	
draw_7x7_texture: # $a0 stores the address of the texture, $a1 the x coord, $a2 the y coord
	li $t3, 64
	mult $t3, $a2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $a1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	lw $t2, 0($a0)		# $t2 gets the texture array
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)	
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)		
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)	
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)		
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)		
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	li $t5, 28
	add $a0, $a0, $t5
	
	lw $t2, 0($a0)		
	sw $t2, 0($t4)
	lw $t2, 4($a0)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($a0)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($a0)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($a0)		# next pixel
	sw $t2, 16($t4)
	lw $t2, 20($a0)		# next pixel
	sw $t2, 20($t4)
	lw $t2, 24($a0)		# next pixel
	sw $t2, 24($t4)
	
	jr $ra
	
erase_7x7_texture: # $a1 the x coord, $a2 the y coord
	li $t3, 64
	mult $t3, $a2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $a1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	li $t2, BLACK
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	li $t5, 256
	add $t4, $t4, $t5
	
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	sw $t2, 24($t4)
	
	jr $ra
	
erase_ship:
# calculate old location offset (ship)
	la $t0, ship_x
	lw $t1, 0($t0)		# $t1 gets the x coordinate of the ship
	la $t0, ship_y
	lw $t2, 0($t0) 		# $t2 gets the y coordinate of the ship
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address

# erase old ship
	li $t1, BLACK
	
	sw $t1, -520($t4)
	sw $t1, -516($t4)
	sw $t1, -512($t4)
	sw $t1, -508($t4)

	sw $t1, -260($t4)
	sw $t1, -256($t4)
	sw $t1, -252($t4)
	sw $t1, -248($t4)

	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 12($t4)
	
	sw $t1, 252($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	sw $t1, 264($t4)
	
	sw $t1, 504($t4)
	sw $t1, 508($t4)
	sw $t1, 512($t4)
	sw $t1, 516($t4)
	jr $ra

draw_number: # $a0 stores the number to be drawn, $a1 the x coord to do so, $a2 the y coord
	li $t3, 64
	mult $t3, $a2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $a1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address

	la $t1, number_textures
	li $t5, 140
	mult $t5, $a0
	mflo $t5
	add $t1, $t1, $t5
	
	lw $t2, 0($t1)		# $t2 gets the texture array
	sw $t2, 0($t4)
	lw $t2, 4($t1)		# next pixel
	sw $t2, 4($t4)
	lw $t2, 8($t1)		# next pixel
	sw $t2, 8($t4)
	lw $t2, 12($t1)		# next pixel
	sw $t2, 12($t4)
	lw $t2, 16($t1)		# next pixel
	sw $t2, 16($t4)
	
	lw $t2, 20($t1)		# next pixel
	sw $t2, 256($t4)
	lw $t2, 24($t1)		# next pixel
	sw $t2, 260($t4)
	lw $t2, 28($t1)		# next pixel
	sw $t2, 264($t4)
	lw $t2, 32($t1)		# next pixel
	sw $t2, 268($t4)
	lw $t2, 36($t1)		# next pixel
	sw $t2, 272($t4)
	
	lw $t2, 40($t1)		# next pixel
	sw $t2, 512($t4)
	lw $t2, 44($t1)		# next pixel
	sw $t2, 516($t4)
	lw $t2, 48($t1)		# next pixel
	sw $t2, 520($t4)
	lw $t2, 52($t1)		# next pixel
	sw $t2, 524($t4)
	lw $t2, 56($t1)		# next pixel
	sw $t2, 528($t4)
	
	lw $t2, 60($t1)		# next pixel
	sw $t2, 768($t4)
	lw $t2, 64($t1)		# next pixel
	sw $t2, 772($t4)
	lw $t2, 68($t1)		# next pixel
	sw $t2, 776($t4)
	lw $t2, 72($t1)		# next pixel
	sw $t2, 780($t4)
	lw $t2, 76($t1)		# next pixel
	sw $t2, 784($t4)
	
	lw $t2, 80($t1)		# next pixel
	sw $t2, 1024($t4)
	lw $t2, 84($t1)		# next pixel
	sw $t2, 1028($t4)
	lw $t2, 88($t1)		# next pixel
	sw $t2, 1032($t4)
	lw $t2, 92($t1)		# next pixel
	sw $t2, 1036($t4)
	lw $t2, 96($t1)		# next pixel
	sw $t2, 1040($t4)

	lw $t2, 100($t1)		# next pixel
	sw $t2, 1280($t4)
	lw $t2, 104($t1)		# next pixel
	sw $t2, 1284($t4)
	lw $t2, 108($t1)		# next pixel
	sw $t2, 1288($t4)
	lw $t2, 112($t1)		# next pixel
	sw $t2, 1292($t4)
	lw $t2, 116($t1)		# next pixel
	sw $t2, 1296($t4)
	
	lw $t2, 120($t1)		# next pixel
	sw $t2, 1536($t4)
	lw $t2, 124($t1)		# next pixel
	sw $t2, 1540($t4)
	lw $t2, 128($t1)		# next pixel
	sw $t2, 1544($t4)
	lw $t2, 132($t1)		# next pixel
	sw $t2, 1548($t4)
	lw $t2, 136($t1)		# next pixel
	sw $t2, 1552($t4)

	jr $ra

draw_wormhole:	# $a0 is the y level at which the wormhole is at
	addi $a0, $a0, 3
	li $t3, 64
	mult $t3, $a0
	mflo $t4		# $t4 stores 64 * (y coordinate)
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the (y coordinate) * 64 * 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	move $t7, $t4
	li $t1, WORMHOLE_COLOUR
	
	li $t5, 0
	li $t6, 16
worm_loop:
	beq $t5, $t6, end_worm_loop
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	addi $t5, $t5, 1
	addi $t4, $t4, 16
	j worm_loop
end_worm_loop:
	li $t5, 0
	li $t6, 16
worm_loop2:
	beq $t5, $t6, end_worm_loop2
	sw $t1, 264($t7)
	sw $t1, 268($t7)
	addi $t5, $t5, 1
	addi $t7, $t7, 16
	j worm_loop2
end_worm_loop2:
	jr $ra

erase_wormhole:	# $a0 is the y level at which the wormhole is at
	addi $a0, $a0, 3
	li $t3, 64
	mult $t3, $a0
	mflo $t4		# $t4 stores 64 * (y coordinate)
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the (y coordinate) * 64 * 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	move $t7, $t4
	li $t1, BLACK
	
	li $t5, 0
	li $t6, 16
worm_loop_erase:
	beq $t5, $t6, end_worm_loop_erase
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	addi $t5, $t5, 1
	addi $t4, $t4, 16
	j worm_loop_erase
end_worm_loop_erase:
	li $t5, 0
	li $t6, 16
worm_loop2_erase:
	beq $t5, $t6, end_worm_loop2_erase
	sw $t1, 264($t7)
	sw $t1, 268($t7)
	addi $t5, $t5, 1
	addi $t7, $t7, 16
	j worm_loop2_erase
end_worm_loop2_erase:
	jr $ra

draw_bullet:
	la $t0, bullet
	
	lw $t1, 0($t0)	# $t1 gets the x coord
	lw $t2, 4($t0)	# $t2 gets the y coord
	
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	li $t7, WHITE	# white pixel
	sw $t7, 0($t4)
	
	jr $ra
	
erase_bullet:
	la $t0, bullet
	
	lw $t1, 0($t0)	# $t1 gets the x coord
	lw $t2, 4($t0)	# $t2 gets the y coord
	
	li $t3, 64
	mult $t3, $t2
	mflo $t3		# $t3 stores 64 * (y coordinate)
	add $t4, $t3, $t1	# $t4 stores 64 * (y coordinate) + (x coordinate), this is the offset
	li $t3, 4
	mult $t4, $t3
	mflo $t4		# $t4 now stores the offset multiplied by 4
	li $t0, BASE_ADDRESS
	add $t4, $t4, $t0	# $t4 now stores the offset multiplied by 4 added to the base address
	
	li $t7, BLACK	# white pixel
	sw $t7, 0($t4)
	
	jr $ra

chk_bullet_collision: # $a0 stores the address of the obstacle we are to check
	lw $t1, 0($a0)		# $t1 stores the x coord of obstacle
	lw $t2, 4($a0)		# $t2 stores the y coord of obstacle
	lw $t3, 8($a0)		# $t3 stores the size of the obstacle
	
	la $t0, bullet
	lw $t4, 0($t0)		# $t4 gets the bullet's x coord
	lw $t5, 4($t0)		# $t5 gets the bullet's y coord
	
	sub $t4, $t4, $t1	# $t4 now stores the difference between the x coords
	sub $t5, $t5, $t2	# $t5 now stores the difference between the y coords
	
	li $t0, 1
	beq $t3, $t0, chk_bullet_collision_med
	li $t0, 2
	beq $t3, $t0, chk_bullet_collision_big
chk_bullet_collision_small:
	li $t0, 2
	bge $t4, $t0, no_bullet_collision
	bge $t5, $t0, no_bullet_collision
	li $t0, -2
	ble $t4, $t0, no_bullet_collision
	ble $t5, $t0, no_bullet_collision
	j bullet_collision
chk_bullet_collision_med:
	li $t0, 3
	bge $t4, $t0, no_bullet_collision
	bge $t5, $t0, no_bullet_collision
	li $t0, -3
	ble $t4, $t0, no_bullet_collision
	ble $t5, $t0, no_bullet_collision
	j bullet_collision
chk_bullet_collision_big:
	li $t0, 4
	bge $t4, $t0, no_bullet_collision
	bge $t5, $t0, no_bullet_collision
	li $t0, -4
	ble $t4, $t0, no_bullet_collision
	ble $t5, $t0, no_bullet_collision
	j bullet_collision
bullet_collision:
	la $t0, bullet
	# deactivate the bullet
	sw $zero, 8($t0) 
	# destroy the obstacle
	
	move $t0, $a0	# spawn in a new randomized obstacle, but it needs to come from the right side (x = 61)
	li $v0, 42
	
	li $a0, 0 # y coord randomized
	move $a1, $s4
	syscall
	sw $a0, 4($t0)

	li $t5, 61 # x coord should be 61
	sw $t5, 0($t0)
	
	li $a0, 0 # size randomized
	li $a1, 3
	syscall
	sw $a0, 8($t0)
	
	li $a0, 0 # texture randomized
	li $a1, 2
	syscall
	sw $a0, 12($t0)
	
	li $a0, 0 # velocity randomized
	li $a1, 3
	syscall
	addi $a0, $a0, 1
	sw $a0, 16($t0)
	
	sw $zero, 20($t0) # set hit state to 0
	addi $s3, $s3, 1
	
	jr $ra
no_bullet_collision:
	jr $ra
