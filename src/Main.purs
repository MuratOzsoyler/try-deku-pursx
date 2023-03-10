module Main where

import Prelude

import Debug (spy)
import Deku.Control (blank, text_, (<#~>))
import Deku.Core (fixed)
import Deku.Pursx ((~~))
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import FRP.Event (burning, create)
import Type.Proxy (Proxy(..))

-- tableData ∷ Array { code ∷ Int, explanation ∷ String }
-- tableData = [ { code: 1, explanation: "Expl 1" }, { code: 23, explanation: "Expl 23" } ]

main :: Effect Unit
main = do
  { push: setTableData, event: tableData' } <- create
  { event: tableData } <- burning { code: 1, explanation: "Expl 1" } tableData'
  launchAff_ do
    delay $ Milliseconds 100.0
    liftEffect $ setTableData { code: 23, explanation: "Expl 23" }

  runInBody
    ( table_ ~~
        { rows: fixed
            [ tableData <#~> \{ code, explanation } ->
                row_ ~~ { code: fixed [ text_ $ spy "code" $ show code ], explanation: fixed [ text_ explanation ] }
            ]
        }
    )

row_ =
  Proxy
    :: Proxy
         """<tr>
    <td>

      ~code~

    </td>
    <td>

      ~explanation~

    </td>
</tr>
"""

table_ =
  Proxy
    :: Proxy
         """<div>
    <table>
        <thead>
            <tr>
                <th>Code</th>
                <th>Explanation</th>
            </tr>
        </thead>
        <tbody>

            ~rows~

        </tbody>
    </table>
</div>
"""