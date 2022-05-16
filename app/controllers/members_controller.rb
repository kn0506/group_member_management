class MembersController < ApplicationController
  def index
    @members = Member.all.limit(50)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def edit
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to action: :index
    else
      render :new
    end
  end

  def destroy
    Member.find(params[:id]).destroy!
    redirect_to action: :index
  end

  private

  def member_params
    params.require(:member).permit(:name)
  end
end
