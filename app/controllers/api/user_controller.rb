class Api::UserController < Api::ApiController
  
  before_filter :set_user , :only => [:user_info,:friend,:user,:follow]

  def list
  	@result = ::AppUser.paginate(:per_page => Settings.app.users_limit, :page => params[:page]).map(&:to_api_hash)
  end


  def info
    @result = params[:full] ?  $current_user.to_full_api_hash :  $current_user.to_api_hash
  end

  def user_info
  	@result = params[:full] ?  @user.to_full_api_hash :  @user.to_api_hash
  end

  def upload_avatar
    picture = params[:photo].nil? ? (raise Api::Exception.new(8)) : params[:photo]
    prx = !params[:bg].nil? && params[:bg].to_i == 1 ? "#{$current_user.id}_bg": $current_user.id 
    $current_user.update_attribute prx == $current_user.id ? :avatar : :avatar_bg , "http://#{request.host}#{Tools.process_picture(params[:photo],prx,Settings.app.avatar)}"
    @result = $current_user.to_full_api_hash
  end


  def follow
  	$current_user.follow!(@user)
    following(true)
  end

  def edit
    attrs = {}
    attrs.merge!(:name =>params[:name]) unless params[:name].nil?
    attrs.merge!(:email=>params[:name]) unless params[:email].nil?
    raise Api::Exception.new(14) unless attrs.keys.any?
    $current_user.update_attribute(attrs)
    @result = {:success=>true}
  end

  def followers
    set_user unless params[:user_id].nil?
    user = @user.nil? ? $current_user : @user
    @result = {:total=>user.followers.count,:items=>user.followers.map(&:to_api_hash)}
  end

  def following(current_user = false)
    set_user unless current_user
    user = current_user || @user.nil? ? $current_user : @user
    @result = {:total=>user.following.count,:items=>user.following.map(&:to_api_hash)}
  end


  private

  def set_user
  	id = params[:user_id] || 0
    @user = ::AppUser.where(id:id.to_i).first
    raise Api::Exception.new(9) if @user.nil?
  end


end
