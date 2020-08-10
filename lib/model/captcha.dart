class Captcha {
  String captchaImage;
  String idKey;

  Captcha({this.captchaImage, this.idKey});

  Captcha.fromJson(Map<String, dynamic> json) {
    captchaImage = json['captcha_image'];
    idKey = json['id_key'];
  }
}