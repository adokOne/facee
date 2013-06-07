class Api::UserController < Api::ApiController
  
  before_filter :set_user , :only => [:user_info,:friend,:user]

  def list
  	@result = ::AppUser.paginate(:per_page => Settings.app.users_limit, :page => params[:page]).map{|i| i.to_api_hash}
  end


  def info
    @result = params[:full] ?  $current_user.to_full_api_hash :  $current_user.to_api_hash
  end

  def user_info
  	@result = params[:full] ?  @user.to_full_api_hash :  @user.to_api_hash
  end

  def follow
  	$current_user.follow!(@user)
    following
  end

  def friend
  	$current_user.friend!(@user)
  end

  def friends
  	@result =  $current_user.friends.map{|u| u.to_api_hash}
  end

  def followers
  	@result = $current_user.followers.map{|u| u.to_api_hash}
  end

  def following
  	@result = $current_user.following.map{|u| u.to_api_hash}
  end


  private

  def set_user
  	id = params[:user_id] || 0
    @user = ::AppUser.where(id:id.to_i).first
    raise Api::Exception.new(9) if @user.nil?
  end


end
