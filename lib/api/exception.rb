class Api::Exception < StandardError
    def initialize code 
      super I18n.t("api.errors.e_#{code}")
      Api::Logger.log(self.message)
    end
end