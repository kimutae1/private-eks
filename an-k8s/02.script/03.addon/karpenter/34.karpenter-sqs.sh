# Karpenter SQS Create
cat << EOF > karpenter-sqs.yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Resources used by https://github.com/aws/karpenter
Resources:
  KarpenterInterruptionQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: !Sub "karpenter-sqs"
      MessageRetentionPeriod: 300
      SqsManagedSseEnabled: true
  KarpenterInterruptionQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref KarpenterInterruptionQueue
      PolicyDocument:
        Id: EC2InterruptionPolicy
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - events.amazonaws.com
                - sqs.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt KarpenterInterruptionQueue.Arn
  ScheduledChangeRule:
    Type: 'AWS::Events::Rule'
    Properties:
      Name: karpenter-ScheduledChangeRule
      EventPattern:
        source:
          - aws.health
        detail-type:
          - AWS Health Event
      Targets:
        - Id: KarpenterInterruptionQueueTarget
          Arn: !GetAtt KarpenterInterruptionQueue.Arn
  SpotInterruptionRule:
    Type: 'AWS::Events::Rule'
    Properties:
      Name: karpenter-SpotInterruptionRule
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - EC2 Spot Instance Interruption Warning
      Targets:
        - Id: KarpenterInterruptionQueueTarget
          Arn: !GetAtt KarpenterInterruptionQueue.Arn
  RebalanceRule:
    Type: 'AWS::Events::Rule'
    Properties:
      Name: karpenter-RebalanceRule
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - EC2 Instance Rebalance Recommendation
      Targets:
        - Id: KarpenterInterruptionQueueTarget
          Arn: !GetAtt KarpenterInterruptionQueue.Arn
  InstanceStateChangeRule:
    Type: 'AWS::Events::Rule'
    Properties:
      Name: karpenter-InstanceStateChangeRule
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - EC2 Instance State-change Notification
      Targets:
        - Id: KarpenterInterruptionQueueTarget
          Arn: !GetAtt KarpenterInterruptionQueue.Arn
EOF

aws cloudformation deploy \
  --stack-name karpenter-sqs \
  --template-file karpenter-sqs.yaml