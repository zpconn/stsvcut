module Lib
    ( runCutter
    ) where

import           Pipes
import qualified Pipes.Prelude as P
import qualified Data.Map.Strict as M
import           Data.List.Split (splitOn)
import           Data.List (intercalate)
import           Data.Maybe (fromMaybe)
import           Control.Monad (forever)
import           Control.Monad.IO.Class (liftIO)
import           System.IO (hFlush, stdout)

consecutivePairs :: [a] -> [(a,a)]
consecutivePairs []       = []
consecutivePairs (x:y:zs) = (x,y) : consecutivePairs zs
consecutivePairs [x]      = []

extractFieldsPipe :: [String] -> Pipe String String IO ()
extractFieldsPipe fields = forever $ do
    line <- await
    let tsv = M.fromList . consecutivePairs . splitOn "\t" $ line
        vals = map (\field -> fromMaybe "" $ M.lookup field tsv) fields
    yield $ intercalate "\t" vals
    liftIO $ hFlush stdout

runCutter :: [String] -> IO ()
runCutter fields = runEffect $ P.stdinLn >-> extractFieldsPipe fields >-> P.stdoutLn

