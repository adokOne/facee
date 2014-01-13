class Api::PicturesController < Api::ApiController

  before_filter :set_photo ,:only=>[:info]
  before_filter :authorize

  def list
    set_user unless params[:user_id].nil?
    user = @user.nil? ? $current_user : @user
    total = ::Photo.where(:app_user=>user.id).count
    items = ::Photo.where(:app_user=>user.id).paginate(:per_page => Settings.app.photos_limit, :page => params[:page]).map(&:to_json)
  	@result = {:total=>total,:items=>items}
  end

  def info
    @result =  @photo.to_json
  end

  def post
    @photo   = ::Photo.new
    params[:bd].nil?     && !@photo.is_own  ? (@photo.delete ; raise Api::Exception.new(15)) : @photo.update_attribute(:bd,params[:bd].to_i)
    picture = params[:photo].nil?           ? (@photo.delete ; raise Api::Exception.new(8))  : params[:photo]
    @photo.picture = picture.tempfile
    @photo.save
    @result = {:success=>true}
  end

  private

  def authorize
      ::AppUser.login(params[:app_id])
      $current_user.update_activity
  end
  
  def set_photo
    id     = params[:photo_id] || 0
    @photo = ::Photo.where(id:id.to_i).first
    raise Api::Exception.new(3) if @photo.nil?
  end

  def set_user
    id = params[:user_id] || 0
    @user = ::AppUser.where(id:id.to_i).first
    raise Api::Exception.new(9) if @user.nil?
  end


end
