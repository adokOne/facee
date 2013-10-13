class Api::PicturesController < Api::ApiController

  before_filter :set_photo ,:only=>[:delete,:info,:like,:set_attr,:pay,:like_list]

  def list
    set_user unless params[:user_id].nil?
    user = @user.nil? ? $current_user : @user
    total = ::Photo.where(:app_user=>user.id).count
    items = ::Photo.where(:app_user=>user.id).paginate(:per_page => Settings.app.photos_limit, :page => params[:page]).map{|photo| params[:full].nil? ? photo.to_json : photo.to_strim}
  	@result = {:total=>total,:items=>items}
  end

  def info
    @result = params[:full].nil? ?  @photo.to_json : @photo.to_full_json
  end

  def post
    @photo   = ::Photo.new
    picture = params[:photo].nil? ? (raise Api::Exception.new(8)) : params[:photo]
    @photo.picture = picture.tempfile
    @photo.save
    params[:bd].nil?     ? (raise Api::Exception.new(15)) : @photo.update_attribute(:b_day,params[:bd])
    params[:gender].nil? ? (raise Api::Exception.new(16)) : @photo.update_attribute(:gender,params[:gender].to_i)
    info
  end

  def strim
    total = ::Photo.count
    items = ::Photo.paginate(:per_page => Settings.app.photos_limit, :page => params[:page]).map(&:to_strim)
    @result = {:total=>total,:items=>items}
  end

  def like_list
    @result =  @photo.likes.map { |e|  e.app_user.nil? ? nil : e.app_user.to_api_hash }.compact
  end

  def like
    @result = {:type=> @photo.like!,:success=>true,:like_count=>@photo.likes.count}
  end

  def delete
    is_own? ? @photo.delete : (raise Api::Exception.new(7))
    FileUtils.rm_rf "#{Rails.root}/public/photos/#{$current_user.id}/#{@photo.id}"
    @result = {:success=>true}
  end

  def set_attr
    raise Api::Exception.new(7) unless is_own? 
    raise Api::Exception.new(12) if params[:attributes].nil? || params[:attributes].split(",").count < 1 
    desc = ::Description.find(params[:attributes].split(",").map(&:to_i)) 
    @photo.descriptions << desc
    @photo.save
    @result = {:success=>true}
  rescue 
    raise Api::Exception.new(13) 
  end

  def pay
    raise Api::Exception.new(7) unless is_own? 
    @photo.update_attribute :description_payed, true
    @result = {:success=>true}
  end


  private

  def is_own?
    $current_user.photos.include? @photo
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
