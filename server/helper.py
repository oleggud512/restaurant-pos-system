import base64
image = open('Bla.png', 'rb') 
image_read = image.read() 
print(image_read)
input()
image_64_encode = base64.encodebytes(image_read) # из картинки в base64
print(image_64_encode)
print(type(image_64_encode))
input()
image_64_decode = base64.decodebytes(image_64_encode) # из base64 в картинку
print('\n\n\n\n\n')
print(image_64_decode)
image.close()
new_img = open('new.jpg', 'wb')
new_img.write(image_64_decode)
new_img.close()

