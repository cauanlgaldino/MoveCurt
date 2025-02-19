import SwiftUI

struct CurtainView: View {
    let pProportion = 0.045 // Proporção da largura da peça menor (P)
    let gProportion = 0.033 // Proporção da largura da peça maior (G)
    let oProportion = 0.033 * 5 // Proporção da largura da peça maior (G)
    let sWidth: CGFloat
    let sHeight: CGFloat
    
    @EnvironmentObject var vm: CurtainViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            Image("V05") // Varão
                .resizable()
                .frame(maxWidth: sWidth * 0.89, maxHeight: sWidth * gProportion)
                .aspectRatio(contentMode: .fill)
            HStack(alignment: .top, spacing: -1) {
                // Lado Esquerdo
                HStack(alignment: .top, spacing: -1) {
                    Image("BE05")
                        .resizable()
                        .frame(width: sWidth * pProportion, height: sHeight * 0.3)
                    ForEach(0..<vm.numPieces, id: \.self) { i in
                        Group {
                            Image("P05")
                                .resizable()
                                .frame(width: sWidth * pProportion, height: sHeight * 0.28)
                                .zIndex(-1)
                            Image("G05")
                                .resizable()
                                .frame(width: sWidth * gProportion, height: sHeight * 0.29)
                                .overlay(content: {
                                    if i == 4 {
                                        VStack {
                                            Image("A05")
                                                .resizable()
                                                .frame(width: sWidth * gProportion * 0.5, height: sWidth * gProportion)
                                                .offset(y: -sWidth * gProportion * 0.5)
                                            Spacer()
                                        }
                                    }
                                })
                            
                        }
                        .offset(x: sWidth * vm.leftOffsets[i] * oProportion)
                    }
                }
                
                // Lado Direito
                HStack(alignment: .top, spacing: -1) {
                    ForEach(0..<vm.numPieces, id: \.self) { i in
                        Group {
                            Image("G05")
                                .resizable()
                                .frame(width: sWidth * gProportion, height: sHeight * 0.29)
                                .zIndex(1)
                                .overlay(content: {
                                    if i == 0 {
                                        VStack {
                                            Image("A05")
                                                .resizable()
                                                .frame(width: sWidth * gProportion * 0.5, height: sWidth * gProportion)
                                                .offset(y: -sWidth * gProportion * 0.5)
                                            Spacer()
                                        }
                                    }
                                })
                            Image("P05")
                                .resizable()
                                .frame(width: sWidth * pProportion, height: sHeight * 0.28)
                                
                        }
                        .offset(x: sWidth * vm.rightOffsets[i] * oProportion)
//                        .animation(.linear(duration: vm.rightAnimationDuration))
                    }
                    Image("BD05")
                        .resizable()
                        .frame(width: sWidth * pProportion, height: sHeight * 0.3)
                }
            }
        }
        .onChange(of: vm.leftOpeningPercentage) {
            vm.updateOffsets(isLeft: true)
//            vm.leftTargetOpening = vm.leftOpeningPercentage
            
        }
        .onChange(of: vm.rightOpeningPercentage) {
            vm.updateOffsets(isLeft: false)
//            vm.rightTargetOpening = vm.rightOpeningPercentage
            
        }
    }
}
