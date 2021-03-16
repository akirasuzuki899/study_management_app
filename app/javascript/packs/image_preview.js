if (document.URL.match(/study_materials\/new/) || document.URL.match(/study_materials\/[0-9]{1,}\/edit/)){
  document.addEventListener('DOMContentLoaded', function(){
    const ImageList = document.getElementById('image-list');
    console.log('DOMContentLoaded が動いた');
    document.getElementById('study_material_picture').addEventListener('change', function(e){
      console.log('change が動いた')
      // 画像が表示されている場合のみ、すでに存在している画像を削除する
      const imageContent = document.querySelector('img');
      if (imageContent){
        imageContent.remove();
      }
  
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      
  
      // 画像を表示するためのdiv要素を生成
      const imageElement = document.createElement('div');

       // 表示する画像を生成
       const blobImage = document.createElement('img');
       blobImage.setAttribute('src', blob);
  
       imageElement.appendChild(blobImage);
       ImageList.appendChild(imageElement);
    });
  });
}