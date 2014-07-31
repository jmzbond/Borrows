class Outstanding
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	recurs { daily }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto set status to N/A if borrows are still outstanding on their pickup date
			Borrow.where(status1: 1).select { |b| b.request.pickupdate == Date.today}.each do |b|
				# b.update_attributes(status1 == 20)
				RequestMailer.not_found(b, b.itemlist_id).deliver
			end

		end
	end
end