import ARKit
import SceneKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var ar_pictures:[UIImage] = []
    @IBOutlet weak var arScnView: ARSCNView!
    private var collectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        arScnView.scene = scene
        // Do any additional setup after loading the view, typically from a nib.
        
        //UICollectionViewのレイアウトを生成
        let layout = UICollectionViewFlowLayout()
        
        //cellの大きさ
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        
        //cellの上下左右の余白。(top,left,bottom,right)
        //        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        //セクションのサイズ
        //        layout.headerReferenceSize = CGSize(width:80,height:50)
        layout.scrollDirection = .horizontal
        
        
        //UICollectionViewのインスタンス生成
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height / 2.5, width: self.view.frame.width, height: self.view.frame.height / 2), collectionViewLayout: layout)
        
        //collectionViewの背景色を設定
        collectionView.backgroundColor = UIColor.clear
        
        // Cellに使われるクラスを登録.
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        //Delegateの設定
        collectionView.delegate = self
        
        //DataSourceの設定
        collectionView.dataSource = self
        
        collectionView.isHidden = true
        
        //ViewにcollectionViewをSubViewとして追加
        self.view.addSubview(collectionView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //cell選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //cellの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //cellの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        arScnView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        arScnView.session.pause()
    }
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print("tapped")
        guard let currentFrame = arScnView.session.currentFrame else { return  }
        
        let viewWidth  = arScnView.bounds.width
        let viewHeight = arScnView.bounds.height
        let imagePlane = SCNPlane(width: viewHeight * ar_pictures[ar_pictures.count - 1].size.width/6000/ar_pictures[0].size.height, height: viewHeight/6000)
        imagePlane.firstMaterial?.diffuse.contents = ar_pictures[ar_pictures.count - 1]
        imagePlane.firstMaterial?.lightingModel = .constant
        
        let planeNode = SCNNode(geometry: imagePlane)
        arScnView.scene.rootNode.addChildNode(planeNode)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        //        let position = SCNVector3(x: 0, y: 0, z: -0.5) // ノードの位置は、左右：0m 上下：0m　奥に50cm
        if let camera = arScnView.pointOfView {
            //            planeNode.position = camera.convertPosition(position, to: nil) // カメラ位置からの偏差で求めた位置
            planeNode.eulerAngles = camera.eulerAngles  // カメラのオイラー角と同じにす
        }
        
        //        planeNode.rotation = SCNVector4(300, 200, 100, 10)
    }
    
    @IBAction func open_menu()
    {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image1 = info[.originalImage] as! UIImage
        ar_pictures.append(image1)
        self.dismiss(animated: true, completion: nil)
    }
    
}
