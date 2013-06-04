class Api::UserController < Api::ApiController
  
  before_filter :set_user , :except => [:list,:info,:friends,:folowers]

  def list
  	@result = ::AppUser.paginate(:per_page => Settings.app.users_limit, :page => params[:page]).to_json
  end


  def info
    @result = params[:full] ?  $current_user.to_full_json :  $current_user.to_json
  end

  def user_info
  	@result = params[:full] ?  @user.to_full_json :  @user.to_json
  end

  def follow
  	$current_user.follow!(@user)
  end

  def unfollow
  	$current_user.follow!(@user)
  end


  def friend
  	$current_user.friend!(@user)
  end

  def unfriend
  	$current_user.unfriend!(@user)
  end


  def friends
  	p $current_user.friends
  end

  def followers
  	p $current_user.followers
  end

  def following
  	p $current_user.followers
  end


  private

  def set_user
  	id = params[:user_id] || 0
    @user = ::AppUser.where(id:id.to_i).first
    raise Api::Exception.new(9) if @user.nil?
  end


end
