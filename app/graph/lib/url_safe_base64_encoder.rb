module URLSafeBase64Encoder
  def self.encode(txt, nonce: false)
    Base64.urlsafe_encode64(txt)
  end

  def self.decode(txt, nonce: false)
    Base64.urlsafe_decode64(txt)
  end
end
