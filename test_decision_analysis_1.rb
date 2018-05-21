		decisionroom = Decisionroom.find(7)
		array = Array.wrap(nil)

		#SelectRelevantVotes
		# There is an array (B) in an array(A). Each array (B) represents the votes of one certain user.
		# Array (A) contains all Array (B), consequently the votes of all users
		User.where(decisionroom_id: decisionroom.id).each do |u|
			array1 = Array.wrap(nil)
			Alternative.where(decisionroom_id: decisionroom.id).each do |a|
				Criterion.where(decisionroom_id: decisionroom.id).each do |c|
					vote = Vote.find_by(user_id: u.id, alternative_id: a.id, criterion_id: c.id).value
					array1.push(vote)
				end
			end
			array.push(array1)
		end

		# Inserting the user who votes always the average!!
		# Important: Always the last user of all users (array) is the average voter!!
		
		averageUser = Array.wrap(nil)
		array[0].each_with_index do |vote, vote_i|
			sum = 0
			array.each do |user|
				sum += user[vote_i]
			end
			averageUser.push(sum / array.count.to_f)
		end
		array.push(averageUser)


		#DetermineAbsoluteDeviation
		# i represents the user which is currently the focal one
		# j represents the user, whoms votes are compared to user i
		# k represents the vote either of user i or user k
		# relation represents the relation between the votes comparsions of the corresponsive users
		
		absDev = Array.wrap(nil)
		relation = Array.wrap(nil)
		array.each_with_index do |a, i|
			break if i == array.count - 1
			j = i
			loop do
				array1 = Array.wrap(nil)
				if j != i then
					array[i].each_with_index do |b,k|
						array1.push((array[i][k] - array[j][k]).abs)
					end
					relation.push([i, j])
					if !array1[0].nil? then
						absDev.push(array1)
					end
				end
				break if j == array.count - 1
				j += 1
			end
		end
		#DetermineConsensforeachRelationoftheusers
		maxDev = (5 - 1) * Criterion.where(decisionroom_id: decisionroom.id).count * Alternative.where(decisionroom_id: decisionroom.id).count
		consensRelation = Array.wrap(nil)
		relation.each_with_index do |rel, j|
			consens = 1 - (absDev[j].sum / maxDev.to_f)
			consensRelation.push([rel[0], rel[1], consens])
		end

		# maxUser is the maximum user index, which represents the average voting user
		# Average voting user needs to be excluded to determine the actual groupconsens
		maxUser = 0
		consensRelation.each do |relC|
			if relC[1] > maxUser then 
				maxUser = relC[1]
			end
		end

		# totalDev = total of deviations of all users
		totalDev = 0
		relation.each_with_index do |rel, j|
			if rel[1] != maxUser then
				totalDev += absDev[j].sum
			end
		end
		#determine number of unique relations between users
		numberUniqueRelations = 0.5 * (decisionroom.users.count ** 2 - decisionroom.users.count)

		#groupconsens is the consens achieved in the hole group
		groupConsens = 1 - (totalDev / (maxDev.to_f * numberUniqueRelations))

		puts "-------------------------------------------"
		puts "uniquerelations:", numberUniqueRelations
		puts "TOTALDEV:", totalDev
		puts "MAXDEV:", maxDev
		puts "USERCOUNT: ", decisionroom.users.count
		puts "groupconsens: ", groupConsens
		##################################################################
		#database import
		#preparation: transform user_index back to user_ids
		decisionroom.users.each_with_index do |user, i|
			consensRelation.each do |relC|
				if i == relC[0] then
					relC[0] = user.id
				end
				if i == relC[1] then
					relC[1] = user.id
				end
			end
		end



