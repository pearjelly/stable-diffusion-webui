from unittest import TestCase


class Test(TestCase):
    def test_proxy_url(self):
        url = 'https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth'
        import proxy.util
        print(proxy.util.proxy_url(url))
        # self.fail()
