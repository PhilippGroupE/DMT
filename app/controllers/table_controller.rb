class TableController < ApplicationController
  def new
  	@decisionroom = Decisionroom.find(params[:decisionroom_id])
  	@table = @decisionroom.tables.build
  end

  def show
  end

  def edit
  end

  def delete
  end
end
