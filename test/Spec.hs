{-# LANGUAGE OverloadedStrings #-}

import Test.Hspec

import Maildir

main :: IO ()
main = hspec $ do
    describe "MaildirT" $ do
        it "initializes a new maildir" $ do
            runMaildir "./testdir" initialize `shouldReturn` ()

