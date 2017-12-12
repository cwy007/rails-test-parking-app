module FlashesHelper
  FLASH_CLASSES = { alert: "danger", notice: "success", warning: "warning" }.freeze

  def flash_class(key)
    FLASH_CLASSES.fetch key.to_sym, key   # 用fetch 方法的第二个参数设定返回默认值
  end

  def user_facing_flashes
    flash.to_hash.slice "alert", "notice", "warning"  # slice 取出这些键并返回
  end
end
