class TeamoutcomeController < ApplicationController
	before_action :logged_in?

	def create
		decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])

		decisionroom.alternatives.each do |alternative|
			decisionroom.criterions.each do |criterion|
				average = Vote.where(alternative_id: alternative.id, criterion_id: criterion.id).average(:value_weighted)
				Teamoutcome.create_outcome(alternative, criterion, average, decisionroom)
			end
		end
		create_decision_analysis_I
		after_create
		
		if decisionroom.save then
			redirect_to decisionroom_teamoutcome_index_path(decisionroom_id: decisionroom.id)
		else
		end
	end

	def after_create
		decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])

		decisionroom.alternatives.each do |alternative|
			sum = Teamoutcome.where(alternative_id: alternative.id, decisionroom_id: decisionroom.id).sum(:average_value)
			TeamoutcomeSum.create(alternative_id: alternative.id, decisionroom_id: decisionroom.id, outcome_sum: sum)
		end

		decisionroom.update_attributes(has_outcome: true)
	end

	def create_decision_analysis_I
		decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
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

		#groupconsens is the consens achieved in the hole group
		groupConsens = 1 - (totalDev / (maxDev.to_f * decisionroom.users.count))

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

		puts "------------------------------------------CONSENSRELATION: ", consensRelation
		#fill FirstDecisionAnalysis Table
		consensRelation.each_with_index do |relC, i|
			if relation[i][1] != maxUser
				FirstDecisionAnalysis.create(decisionroom.id, relC[0], relC[1], relC[2])
			end
		end
		#fill GroupConsens Table
		FirstDecisionAnalysisGroupConsen.create(decisionroom.id, groupConsens)

	end

	def index
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
	end
end
